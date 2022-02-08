require("dotenv").config();
var passport = require("passport");
var LocalStrategy = require("passport-local");
const facebookStrat = require("passport-facebook").Strategy;
const UserModel = require("../models/user.model").getUserModel;
var crypto = require("crypto");

module.exports = function (passport) {
    passport.use(
        new LocalStrategy(
            {
                usernameField: "username",
                passwordField: "password"
            },
            function (username, password, done) {
                UserModel.findOne(
                    { $or: [{ EmailID: username }, { MobileNumber: username }] },
                    function (err, user) {
                        if (err) {
                            return done(err);
                        }
                        if (!user) {
                            return done(null, false);
                        }
                        encryptPassword(password, user.Salt, (err, pwdGen) => {
                            if (err) {
                                return done(err);
                            }
                            if (user && user.password === pwdGen) {
                                return done(null, user);
                            } else {
                                done(null, false);
                            }
                        });
                    }
                );
            }
        )
    );

    //make out facebook stratergy
    passport.use(
        new facebookStrat(
            {
                clientID: process.env.FACEBOOK_CLIENT_ID,
                clientSecret: process.env.FACEBOOK_CLIENT_SECRET,
                callbackURL: process.env.FACEBOOK_CALLBACK_URL,
                profileFields: [
                    "id",
                    "displayName",
                    "email",
                    "name",
                    "gender",
                    "picture.type(large)"
                ]
            },
            function (accessToken, refreshToken, profile, done) {
                process.nextTick(function (req, res) {
                    UserModel.findOne({ FacebookID: profile.id }, function (err, user) {
                        if (err) {
                            return done(err);
                        }
                        if (user) {
                            user.accessToken = accessToken;
                            return done(null, user);
                        } else {

                            let user = new UserModel();
                            user.FacebookID = profile.id;
                            user.FirstName = profile.name.givenName;
                            user.LastName = profile.name.familyName;
                            user.EmailID = profile.emails[0].value;
                            user.save(function (err) {
                                if (err) throw err;
                                user.accessToken = accessToken;
                                return done(null, user);
                            });
                        }
                    });
                });
            }
        )
    );

    passport.serializeUser(function (user, done) {
        done(null, user._id);
    });
    passport.deserializeUser(function (id, done) {
        User.findOne({ _id: id }, function (err, user) {
            done(err, user);
        });
    });
};
function encryptPassword(password, Salt, callback) {
    if (!password || !Salt) {
        return callback("Missing password or Salt");
    }
    var defaultIterations = 10000;
    var defaultKeyLength = 64;
    var Salt = new Buffer.from(Salt, "base64");

    return crypto.pbkdf2(
        password,
        Salt,
        defaultIterations,
        defaultKeyLength,
        "sha1",
        (err, key) => {
            if (err) {
                callback(err);
            } else {
                callback(null, key.toString("base64"));
            }
        }
    );
}
