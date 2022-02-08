const UserRepo = require("../repositories/user.repository");
const checkAuth = require("../middlewares/checkAuth");
var passport = require('passport');
const OTPRepo = require("../repositories/otp.repository");
const { otp_Actions } = require("../utils/otp.util");
const updateHistoriesRepo = require("../repositories/upDateHistories.repostory")
const vehicleRepo = require("../repositories/vehicle.repository");
const PaymentRepo = require("../repositories/payment.repository");
const CustomizationRepo = require("../repositories/customization.repostory");
var EmailService = require('../services/email.service');
var { ForgetPasswordEmail, CreateEmail } = require('../utils/emails.util');

var async = require("async");
let q = require("q")
const axios = require("axios");

exports.createUser = (req, res) => {
  let userData = req.body;

  var checkDuplicationQuery = {
    StatusCode: { $ne: 2 },
    $or: [{ EmailID: userData.EmailID }, { MobileNumber: userData.MobileNumber }]
  };

  UserRepo.FindUserFromDB(true, checkDuplicationQuery, "EmailID MobileNumber").then((existingUsers) => {
    if (existingUsers && existingUsers.EmailID && existingUsers.EmailID == userData.EmailID) {
      res.send({ status: false, message: "A user with this Email ID already exists" });
      return;
    }
    else if (existingUsers && existingUsers.MobileNumber && existingUsers.MobileNumber == userData.MobileNumber) {
      res.send({ status: false, message: "A user with this Mobile Number already exists" });
      return;
    }
    else {
      UserRepo.SaveNewUserInDB(userData).then(async (data) => {

        let otp_query = { MobileNumber: data.MobileNumber, Action: otp_Actions.SIGNUP, Verified: true };
        let OTP_obj = { $set: { UserID: data._id } };

        await OTPRepo.UpdateOTPInDB(otp_query, OTP_obj);
        //await UserDataTransforForApproved(req, userData);
        let token = checkAuth.signToken(data._id);
        EmailService.sendEmail(data, CreateEmail);
        res.status(200).json({ status: true, token: token, user: userData, message: "Account created OTP sended to mobile number" });


      }).catch(err => {
        res.status(500).json({ status: false, error: err })
      });
    }
  }).catch(err => {
    res.status(500).json({ status: false, error: err })
  });
};

exports.login = function (req, res, next) {
  const { LoginWith } = req.body;
  passport.authenticate('local', function (err, user, info) {
    if (err) res.json({ status: false, message: err })
    if (!user) res.json({ status: false, message: LoginWith + ' or Password is in-correct' })
    else {
      req.login(user, function (err) {
        if (err) {
          res.status(500).json({ status: false, message: err })
        } else {
          delete user.Salt;
          delete user.password;
          let token = checkAuth.signToken(user._id);
          res.json({ status: true, message: "Authentication successful", token: token, user: user });
        }
      })
    }
  })(req, res, next);
}

exports.forgotPassword = (req, res) => {
  const { EmailID, new_password } = req.body;
  UserRepo.FindUserFromDB(true, { EmailID: EmailID }, "FirstName EmailID", null, null, null, null, true)
    .then((user) => {
      if (!user) {
        return res.json({ status: false, message: "No User Found" });
      }
      else {
        user.password = new_password;
        user.save().then((success => {
          EmailService.sendEmail(user, ForgetPasswordEmail);
          res.status(200).json({ status: true, message: "Password changed!" });
        })).catch(err => {
          res.status(500).json({ status: false, error: err })
        });
      }
    }).catch(err => {
      res.status(500).json({ status: false, error: err })
    });
}

exports.changePassword = (req, res, next) => {
  const { UserID, password, new_password } = req.body;
  let user_query = { _id: UserID };
  let User_obj = {};

  if (password === new_password) {
    return res.status(200).json({ status: false, message: 'New password should be different from current password' })
  }

  passport.authenticate('local', function (err, user, info) {
    if (err) res.json({ status: false, message: err })
    if (!user) res.json({ status: false, message: 'Password is in-correct' })
    else {
      user.password = new_password;
      user.save().then((success) => {
        res.status(200).json({ status: true, message: 'Password changed!' })
      }).catch(err => {
        res.status(500).json({ status: false, error: err })
      });
    }
  })(req, res, next);
}

exports.getUserProfile = (req, res) => {
  const { UserID } = req.body;
  let profile_query = { UserID: UserID };
  let user_query = { _id: UserID };

  async.parallel({
    PersonalDetails: function (CB) {
      UserRepo.FindUserFromDB(true, user_query).then(function (UserData) {
        CB(null, UserData);
      }, function (err) {
        CB(err);
      });
    },
    VehicleManagement: function (CB) {
      vehicleRepo.FindVehicleFromDB(false, profile_query).then(function (VehicleData) {
        CB(null, VehicleData);
      }, function (err) {
        CB(err);
      })
    },
    Payments: function (CB) {
      PaymentRepo.FindPaymentFromDB(true, profile_query).then(function (PaymentData) {
        CB(null, PaymentData);
      }, function (err) {
        CB(err);
      })
    }
  }, function (err, success) {
    if (err) {
      return res.send(err);
    }
    res.status(200).json({ status: true, PersonalDetails: success.PersonalDetails, VehicleManagement: success.VehicleManagement, Payments: success.Payments });
  });

}

exports.updateUserProfile = (req, res) => {
  const { UserID, UserData } = req.body;
  let query = { _id: UserID };
  let Upadate_obj = { "$set": {} };

  UserRepo.FindUserFromDB(true, query)
    .then(async (User) => {
      if (!User) {
        res.status(200).json({ status: true, message: "User Not Found" });
        return;
      }
      else {
        let previousData = User;

        if (UserData && Object.keys(UserData).length) {
          Upadate_obj["$set"] = UserData;
        }
        await UserRepo.UpdateUserInDB(query, Upadate_obj);
        if (previousData) {
          var updateHistoryDoc = new UpdateHistoryObj(
            'users',
            User._id,
            previousData,
            "Edit User Profile"
          );
          updateHistoriesRepo.SaveNewUpdateHistoriesInDB(updateHistoryDoc);
        };
        res.status(200).json({ status: true, message: "Profile Updated" });
      }

    }).catch(err => {
      console.log('err', err)
      res.status(500).json({ status: false, error: err });
    });
}


exports.addUserResidentialOrOfficeAddress = (req, res) => {
  const { UserID, ResidentialAddress, OfficeAddress } = req.body;
  let query = { _id: UserID };
  let Upadate_obj = {};
  UserRepo.FindUserFromDB(true, query)
    .then(async (User) => {
      if (!User) {
        res.status(200).json({ status: true, message: "User Not Found" });
        return;
      }
      else {
        let previousData = User;

        if (ResidentialAddress && Object.keys(ResidentialAddress).length) {
          if (User.ResidentialAddress.length == 2) {
            res.status(200).json({ status: true, message: "Residential Address have already been added" });
            return;
          }
          Upadate_obj["$push"] = {};
          Upadate_obj["$push"]["ResidentialAddress"] = ResidentialAddress;
        }

        if (OfficeAddress && Object.keys(OfficeAddress).length) {
          if (User.OfficeAddress && Object.keys(User.OfficeAddress).length) {
            res.status(200).json({ status: true, message: "User Already has an office address" });
            return;
          }
          Upadate_obj["$set"] = { OfficeAddress: {} };
          Upadate_obj["$set"]["OfficeAddress"] = OfficeAddress;
        }
        await UserRepo.UpdateUserInDB(query, Upadate_obj);
        if (previousData) {
          var updateHistoryDoc = new UpdateHistoryObj(
            'users',
            User._id,
            previousData,
            "Save User Address"
          );
          updateHistoriesRepo.SaveNewUpdateHistoriesInDB(updateHistoryDoc);
        };
        res.status(200).json({ status: true, message: "Profile Updated" });
      }

    }).catch(err => {
      console.log('err', err)
      res.status(500).json({ status: false, error: err });
    });
}
exports.loginFacebook = (req, res, next) => {
  passport.authenticate('facebook', { scope: 'email' })(req, res, next)
};

exports.facebookCallback = (req, res, next) => {
  const { LoginWith } = req.body;
  return passport.authenticate('facebook', function (err, user, info) {
    if (err) res.json({ status: false, message: err })
    if (!user) res.json({ status: false, message: LoginWith + ' or Password is in-correct' })
    else {
      req.login(user, function (err) {
        if (err) {
          res.status(500).json({ status: false, message: err })
        } else {
          //let token = user.accessToken;
          let token = checkAuth.signToken(user._id);

          res.json({ status: true, message: "Authentication successful", token: token, user: user });
        }
      });
    }
  })(req, res, next)
};



function UserDataTransforForApproved(user) {
  var deferred = q.defer();
  let currentTime = new Date();
  let Obj = {
    "userid": user.id,
    "organismid": process.env.ADMIN_ORGANISM_ID,
    "password": user.password,
    "roleid": "USER",
    "creation_stamp": user.createdAt
  }
  let headers = "";
  headers['Content-Type'] = 'application/json';
  let axios_token_obj = { method: "get", url: "" };
  let axios_userData_obj = { method: "post", url: "", data: Obj };
  let Category = "Admin Token Expiration Time";

  CustomizationRepo.FindCustomizationFromDB(true, { Category: Category }).then((success) => {
    if (success) {
      if (success.TokenExpirationTime < currentTime) {
        axios(axios_token_obj).then(async (axios_token_res) => {
          let update_obj = { $set: { Token: axios_res, TokenExpirationTime: calculateTokenExpirationTime(1) } }
          CustomizationRepo.UpdateCustomizationInDB({ Category: Category }, update_obj);
          axios_userData_obj["headers"]['IDENTITY_KEY'] = axios_token_res;

          axios(axios_userData_obj).then(axios_res => {
            deferred.resolve();
          }).catch(err => {
            deferred.reject(err);
          });
        }).catch(err => {
          deferred.reject(err);
        });
      }
      else {
        axios_userData_obj["headers"]['IDENTITY_KEY'] = success.Token;
        axios(axios_userData_obj).then(axios_res => {
          deferred.resolve();
        }).catch(err => {
          deferred.reject(err);
        });
      }
    }
    else {
      axios(axios_token_obj).then(axios_token_res => {
        axios_userData_obj["headers"]['IDENTITY_KEY'] = axios_token_res;
        let obj = { Category: Category, TokenExpirationTime: calculateTokenExpirationTime(1), Token: axios_res }
        CustomizationRepo.SaveNewCustomizationInDB(obj);
        axios(axios_userData_obj).then(axios_res => {
          deferred.resolve();
        }).catch(err => {
          deferred.reject(err);
        });
      }).catch(err => {
        deferred.reject(err);
      });
    }
  }).catch(err => {
    deferred.reject(err);
  });

  return deferred.promise;
}

function calculateTokenExpirationTime(hours) {
  const newDate = new Date();
  newDate.setHours(newDate.getHours() + hours);
  return newDate;
}

function UpdateHistoryObj(CollectionName, DocumentID, Updates, Functionality) {
  this.CollectionName = CollectionName;
  this.DocumentID = DocumentID;
  this.Updates = Updates;
  this.Functionality = Functionality;
}





