var ParkingModel = require("../models/parking.model").getParkingModel;

exports.SaveNewParkingInDB = function (Obj) {
  let Parking = new ParkingModel(Obj);
  return Parking.save();
};

exports.UpdateParkingInDB = function (
  queryObj,
  updatesObj,
  
) {
  return ParkingModel.updateOne(queryObj, updatesObj, {
    upsert: false,
  });
};

exports.FindParkingFromDB = function (
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
      return ParkingModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .exec();
    }
    else {
      return ParkingModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .lean()
        .exec();
    }
  } else {
    return ParkingModel.find(query)
      .select(selectParams || "")
      .populate(populateParams || "")
      .limit(limit || 0)
      .skip(skip || 0)
      .sort(sortParams || "")
      .lean()
      .exec();

  }
};


