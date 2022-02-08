const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const ObjectId = Schema.ObjectId;

const VehicleSchema = new Schema({
    VehicleType: String,
    VehicleMake: String,
    VehicleModel: String,
    VehicleLicensePlate: String,
    VehicleLicenseID: String,
    DriverType: String,
    UserID: { type: Schema.ObjectId }

}, { timestamps: true });

exports.getVehicleModel = mongoose.model("Vehicles", VehicleSchema);
