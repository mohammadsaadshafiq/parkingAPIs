const VehicleRepo = require("../repositories/vehicle.repository");
const updateHistoriesRepo = require("../repositories/upDateHistories.repostory")

exports.saveVehicle = (req, res) => {
    let VehicleData = req.body;
    VehicleRepo.SaveNewVehicleInDB(VehicleData).then((success) => {
        res.status(200).json({ status: true, VehicleData: success });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}


exports.updateVehicle = (req, res) => {
    const { VehicleID, VehicleData, UserID } = req.body;
    let query = { _id: VehicleID, UserID : UserID};
    let Upadate_obj = { "$set": {} };

    VehicleRepo.FindVehicleFromDB(true, query)
        .then(async (Vehicle) => {
            if (!Vehicle) {
                res.status(200).json({ status: true, message: "Vehicle Not Found" });
                return;
            }
            else {
                let previousData = Vehicle;

                if (VehicleData && Object.keys(VehicleData).length) {
                    Upadate_obj = { $set: VehicleData };
                }
                await VehicleRepo.UpdateVehicleInDB(query, Upadate_obj);
                if (previousData) {
                    var updateHistoryDoc = new UpdateHistoryObj(
                        'vehicles',
                        Vehicle._id,
                        previousData,
                        "Edit User Vehicle"
                    );
                    updateHistoriesRepo.SaveNewUpdateHistoriesInDB(updateHistoryDoc);
                };
                res.status(200).json({ status: true, message: "User Vehicle Updated" });
            }

        }).catch(err => {
            res.status(500).json({ status: false, error: err });
        });
}

exports.removeVehicleDetails = (req, res) => {
    const { VehicleID, UserID } = req.body;
    let query = { _id: VehicleID, UserID: UserID };

    VehicleRepo.FindVehicleFromDB(true, query)
        .then(async (Vehicle) => {
            if (!Vehicle) {
                res.status(200).json({ status: true, message: "Vehicle Doc Not Found" });
                return;
            }
            else {
                let previousData = Vehicle;
                VehicleRepo.DeleteVehicleInDB(query)
                    .then(async () => {
                        if (previousData) {
                            var updateHistoryDoc = new UpdateHistoryObj(
                                'vehicles',
                                Vehicle._id,
                                previousData,
                                "Delete User Vehicle Details"
                            );
                            updateHistoriesRepo.SaveNewUpdateHistoriesInDB(updateHistoryDoc);
                        };
                        res.status(200).json({ status: true, message: "User Vehicle Deleted" });

                    }).catch(err => {
                        console.log(err)
                        res.status(500).json({ status: false, error: err });
                    });

            }

        }).catch(err => {
            console.log(err)
            res.status(500).json({ status: false, error: err });
        });
}


function UpdateHistoryObj(CollectionName, DocumentID, Updates, Functionality) {
    this.CollectionName = CollectionName;
    this.DocumentID = DocumentID;
    this.Updates = Updates;
    this.Functionality = Functionality;
}
