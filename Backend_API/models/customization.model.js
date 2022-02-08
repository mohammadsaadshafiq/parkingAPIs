const mongoose = require("mongoose");
const Schema = mongoose.Schema;



const CustomizationSchema = new Schema({
    Category : String, // "Vehicle Type" , "Vehicle Model", "Token Expiration Time"
    VehicleType: [String], 
    VehicleModel: [String],
    VehicleMake: [String],
    TokenExpirationTime : Date,
    Token : String

},
{ timestamps: true }
);



exports.getCustomizationModel = mongoose.model("customizations", CustomizationSchema);
