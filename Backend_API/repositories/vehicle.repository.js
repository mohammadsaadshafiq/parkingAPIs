var VehicleModel = require("../models/vehicle.model").getVehicleModel;

exports.SaveNewVehicleInDB = function (Obj) {
  let Vehicle = new VehicleModel(Obj);
  return Vehicle.save();
};

exports.UpdateVehicleInDB = function (
  queryObj,
  updatesObj,
  
) {
  return VehicleModel.updateOne(queryObj, updatesObj, {
    upsert: false,
  });
};

exports.FindVehicleFromDB = function (
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
      return VehicleModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .exec();
    }
    else {
      return VehicleModel.findOne(query)
        .select(selectParams || { password: false, Salt: false })
        .populate(populateParams || "")
        .lean()
        .exec();
    }
  } else {
    return VehicleModel.find(query)
      .select(selectParams || "")
      .populate(populateParams || "")
      .limit(limit || 0)
      .skip(skip || 0)
      .sort(sortParams || "")
      .lean()
      .exec();

  }
};

exports.DeleteVehicleInDB = function (
  queryObj  
) {
  return VehicleModel.deleteOne(queryObj);
};
