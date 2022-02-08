var UpdateHistoryModel = require("../models/upDateHistories.model").getUpDateHistoriesModel;

exports.SaveNewUpdateHistoriesInDB = function (Obj) {
  let UpdateHistories = new UpdateHistoryModel(Obj);
  return UpdateHistories.save();
};

exports.UpdateHistoriesInDB = function (
  queryObj,
  updatesObj,
  
) {
  return UpdateHistoryModel.updateOne(queryObj, updatesObj, {
    upsert: false,
  });
};

exports.FindUpdateHistoriesFromDB = function (
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
      return UpdateHistoryModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .exec();
    }
    else {
      return UpdateHistoryModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .lean()
        .exec();
    }
  } else {
    return UpdateHistoryModel.find(query)
      .select(selectParams || "")
      .populate(populateParams || "")
      .limit(limit || 0)
      .skip(skip || 0)
      .sort(sortParams || "")
      .lean()
      .exec();

  }
};


