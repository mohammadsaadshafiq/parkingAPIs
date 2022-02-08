var PaymentModel = require("../models/payment.model").getPaymentModel;

exports.SaveNewPaymentInDB = function (Obj) {
  let Payment = new PaymentModel(Obj);
  return Payment.save();
};

exports.UpdatePaymentInDB = function (
  queryObj,
  updatesObj,
  
) {
  return PaymentModel.updateOne(queryObj, updatesObj, {
    upsert: false,
  });
};

exports.FindPaymentFromDB = function (
  isSingle,
  query,
  selectParams,
  populateParams,
  sortParams,
  limit,
  skip,
  isLeanNotRequired
) {
  if (isSingle) {
    if (isLeanNotRequired) {
      return PaymentModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .exec();
    }
    else {
      return PaymentModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .lean()
        .exec();
    }
  } else {
    return PaymentModel.find(query)
      .select(selectParams || "")
      .populate(populateParams || "")
      .limit(limit || 0)
      .skip(skip || 0)
      .sort(sortParams || "")
      .lean()
      .exec();

  }
};
exports.DeletePaymentInDB = function (
  queryObj  
) {
  return PaymentModel.deleteOne(queryObj);
};

