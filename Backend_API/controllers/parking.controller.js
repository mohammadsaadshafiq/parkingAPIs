const ParkingRepo = require("../repositories/parking.repostory");
let q = require("q");
const { getDataFromUrbioticaAPI } = require("../services/urbioticaAPI.service")


exports.findParkingLocation = async (req, res) => {
    let organismid = process.env.URBIOTICA_ORGANISM_ID;
    let projectid = process.env.URBIOTICA_PROJECT_ID;
    let userID = process.env.URBIOTICA_USER_ID;
    let userPassword = process.env.URBIOTICA_USER_PASSWORD;

    let axios_parkingData_obj = { method: "GET", url: "http://api.urbiotica.net/v2/organisms/" + organismid + "/projects/" + projectid + "/parkings", headers: {} };
    let axios_token_obj = { method: "GET", url: "http://api.urbiotica.net/v2/auth/" + organismid + "/" + userID + "/" + userPassword };

    const regex = new RegExp("^" + req.params.location, "i");

    getDataFromUrbioticaAPI(axios_parkingData_obj, axios_token_obj).then((data) => {
        if (req.params.location) {
            const matchedLocations = data.filter(({ name }) => name.match(regex)).map((finalResult) => {
                return {
                    locationName: finalResult.name,
                    occupancy: finalResult.occupancy,
                    poms: finalResult.poms
                }
            });
            res.status(200).json({ status: true, parkingData: matchedLocations });

        }
        else {
            const matchedLocations = data.map((finalResult) => {
                return {
                    locationName: finalResult.name,
                    occupancy: finalResult.occupancy,
                    poms: finalResult.poms
                }
            });
            res.status(200).json({ status: true, parkingData: matchedLocations });

        }


    }).catch(err => {
        console.log('err', err)
        res.status(500).json({ status: false, error: err })
    });
}

exports.reserveParkingSpot = (req, res) => {
    const ParkingData = req.body;
    ParkingData["CurrentStatus"] = "Reserved";
    if (ParkingData.ParkingDetails && ParkingData.ParkingDetails.Day) {
        let Day = ParkingData.ParkingDetails.Day;
        let Time = ParkingData.ParkingDetails.Time;
        let Minutes = ParkingData.ParkingDetails.Minutes;
        let startDate = new Date(Day);
        let endDate = null;

        startDate.setHours(Time.split(':')[0]);
        startDate.setMinutes(Time.split(':')[1]);

        endDate = new Date(startDate);
        endDate.setMinutes(endDate.getMinutes() + Minutes);

        ParkingData["ParkingStartTime"] = startDate;
        ParkingData["ParkingEndTime"] = endDate;

        if (ParkingData.OriginalParkingFeePerHour) {
            let totalMinutes = dateDiff(startDate,endDate).m;
            ParkingData["TotalParkingFee"] = (ParkingData.OriginalParkingFeePerHour / 60) * totalMinutes;
        }

    }
    ParkingRepo.SaveNewParkingInDB(ParkingData).then(async (data) => {
        res.status(200).json({ status: true, parkingData: data, message: "Parking Spot Reserve successfully" });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}

exports.cancelParkingReservation = (req, res) => {
    const { ParkingID, UserID } = req.body;
    let query = { _id: ParkingID, UserID: UserID, CurrentStatus: "Reserved" }
    let update_obj = { $set: { CurrentStatus: "Canceled", CancellationDate: new Date() } };
    ParkingRepo.UpdateParkingInDB(query, update_obj).then(async (data) => {
        res.status(200).json({ status: true, message: "Parking Spot Cancel successfully" });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}

exports.completeParkingReservation = (req, res) => {
    const { ParkingID, UserID } = req.body;
    let query = { _id: ParkingID, UserID: UserID, CurrentStatus: "Reserved" }
    let update_obj = { $set: { CurrentStatus: "Completed", CompletionDate: new Date() } };
    ParkingRepo.UpdateParkingInDB(query, update_obj).then(async (data) => {
        res.status(200).json({ status: true, message: "Reserve Parking Complete successfully" });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}

exports.ExtendReserveParkingSpot = (req, res) => {
    const { ParkingID, UserID, Minutes ,OriginalParkingFeePerHour} = req.body;
    let query = { _id: ParkingID, UserID: UserID, CurrentStatus: "Reserved" }
    let Total_Charges = 0
    let Parking_Fee = 0;
    ParkingRepo.FindParkingFromDB(true, query).then(async (data) => {
        if (!data) {
            res.status(200).json({ status: true, message: "Parking Not Found" });
            return;
        }
        else {

            if (OriginalParkingFeePerHour) {
                Parking_Fee = (OriginalParkingFeePerHour / 60) * Minutes;
            }
            let ExtendTimeDetails = [
                {
                    ParkingStartTime: data.ParkingStartTime,
                    ParkingEndTime: data.ParkingEndTime,
                    Minutes: Minutes,
                    ParkingFee: Parking_Fee,
                    TotalParkingFee: data.TotalParkingFee,
                    ExtendOn: new Date()
                }
            ]
            let endDate = new Date(data.ParkingEndTime);
            endDate.setMinutes(endDate.getMinutes() + Minutes);

            
            Total_Charges = data.TotalParkingFee + Parking_Fee;

            let update_obj = { $set: { ParkingEndTime: endDate, ExtendTimeDetails: ExtendTimeDetails, TotalParkingFee: Total_Charges } };
            ParkingRepo.UpdateParkingInDB(query, update_obj).then(async (data) => {
                res.status(200).json({ status: true, message: "Time of Reserve Parking Extend successfully" });
            }).catch(err => {
                res.status(500).json({ status: false, error: err })
            });
        }

    }).catch(err => {
        console.log('errerr', err)

        res.status(500).json({ status: false, error: err })
    });

}

exports.getParkingHistories = (req, res) => {
    const { CurrentStatus, UserID, limit, skip } = req.body;
    let query = { UserID: UserID, CurrentStatus, CurrentStatus }

    ParkingRepo.FindParkingFromDB(false, query, null, null, null, limit, skip).then(async (data) => {
        res.status(200).json({ status: true, parkingData: data });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}


exports.getDistance = (req, res) => {
    let { SpotLang, SpothLong, CurrentLang, CurrentLong, google, CB } = req.body;
    var SpotLocation = new google.maps.LatLng(SpotLang, SpothLong);
    var CurrentLocation = new google.maps.LatLng(CurrentLang, CurrentLong);

    var service = new google.maps.DistanceMatrixService();
    service.getDistanceMatrix(
        {
            origins: [CurrentLocation],
            destinations: [SpotLocation],
            travelMode: 'DRIVING',
        }, CB);
}


function dateDiff(str1, str2) {
    console.log('inside date difference!');
    let diff = Date.parse(str2) - Date.parse(str1);

    return isNaN(diff) ? NaN : {
        diff: diff,
        ms: Math.floor(diff % 1000),
        s: Math.floor(diff / 1000 % 60),
        m: Math.floor(diff / 60000 % 60),
        h: Math.floor(diff / 3600000 % 24),
        d: Math.floor(diff / 86400000)
    };
}
function getTime_timezone(dt, timeZone) {
    let timeStr = momentLib.tz(dt, timeZone).format('h:mm:ss a');
    return (timeStr);
}
function getTime(dt) {
    var dateToParse = new Date(dt);
    var hours = Number(dateToParse.getHours());
    var AM_PM = (hours >= 12 ? "PM" : "AM");
    hours = (hours > 12) ? (hours - 12) : hours;
    var mins = Number(dateToParse.getMinutes());
    var timeStr = ((hours < 10 ? ("0" + hours) : hours) + ":" + (mins < 10 ? ("0" + mins) : mins) + " " + AM_PM);
    return (timeStr);
}
function getDate(dt) {
    var dateToParse = new Date(dt);
    var month = Number(dateToParse.getMonth() + 1);
    var date = Number(dateToParse.getDate());
    return ((date < 10 ? ("0" + date) : date) + "/" + (month < 10 ? ("0" + month) : month) + "/" + dateToParse.getFullYear());
}

