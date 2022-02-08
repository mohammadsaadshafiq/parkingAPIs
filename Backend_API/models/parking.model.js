const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const ObjectId = Schema.ObjectId;

const ParkingSchema = new Schema({
    CancellationDate: Date,
    CompletionDate: Date,
    CurrentStatus: String, //Reserved , Completed, Canceled, InProcess
    UserID: { type: ObjectId },
    Vehicle: {
        Name: String,
        Model: String,
        Number: String,
        Type: String,
        ID: { type: ObjectId }
    },
    LocationName: String,
    ParkingSpotName: String,
    ParkingDetails: {
        Day: Date,
        Time: String,
        Minutes: Number,
        BookType: String, //Book By Minutes , Book By Day
        ArrivalDay: Date,
        ArrivalTime: Date,
        LeaveDay: Date,
        LeaveTime: Date,
    },
    ExtendTimeDetails: [
        {
            ParkingStartTime: Date,
            ParkingEndTime: Date,
            Minutes: String,
            ParkingFee: Number,
            TotalParkingFee: Number,
            ExtendOn : Date
        }
    ],
    ParkingStartTime: Date,
    ParkingEndTime: Date,
    TotalParkingFee: Number,
    CurrentLocation : {
        Longitude: Number,
        Latitude: Number
    },
    ParkingSpotLocation :{
        Longitude: Number,
        Latitude: Number
    },
    Distance: Number,
    DistanceUnit: String,
    DistanceTime : Number,
    DistanceTimeUnit: String,
    ParkingSpotNumber : String,
    ParkingDate : Date,
    OriginalParkingFeePerHour : Number,
    ParkingFeeUnit : String
}, { timestamps: true });

exports.getParkingModel = mongoose.model("parkings", ParkingSchema);
