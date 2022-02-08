var CustomizationModel = require("../models/customization.model").getCustomizationModel;

exports.SaveNewCustomizationInDB = function (Obj) {
  let Customization = new CustomizationModel(Obj);
  return Customization.save();
};

exports.UpdateCustomizationInDB = function (
  queryObj,
  updatesObj,
  
) {
  return CustomizationModel.updateOne(queryObj, updatesObj, {
    upsert: false,
  });
};

exports.FindCustomizationFromDB = function (
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
      return CustomizationModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .exec();
    }
    else {
      return CustomizationModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .lean()
        .exec();
    }
  } else {
    return CustomizationModel.find(query)
      .select(selectParams || "")
      .populate(populateParams || "")
      .limit(limit || 0)
      .skip(skip || 0)
      .sort(sortParams || "")
      .lean()
      .exec();

  }
};


