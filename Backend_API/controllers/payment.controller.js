const PaymentRepo = require("../repositories/payment.repository");
const updateHistoriesRepo = require("../repositories/upDateHistories.repostory")

exports.savePaymentDetails = (req, res) => {
    let PaymentData = req.body;
    PaymentRepo.SaveNewPaymentInDB(PaymentData).then((success) => {
        res.status(200).json({ status: true, PaymentData: success });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}

exports.updatePaymentDetails = (req, res) => {
    const { PaymentID, PaymentData, UserID } = req.body;
    let query = { _id: PaymentID, UserID: UserID };
    let Upadate_obj = { "$set": {} };

    PaymentRepo.FindPaymentFromDB(true, query)
        .then(async (Payment) => {
            if (!Payment) {
                res.status(200).json({ status: true, message: "Payment Doc Not Found" });
                return;
            }
            else {
                let previousData = Payment;

                if (PaymentData && Object.keys(PaymentData).length) {
                    Upadate_obj = { $set: PaymentData };
                }
                await PaymentRepo.UpdatePaymentInDB(query, Upadate_obj);
                if (previousData) {
                    var updateHistoryDoc = new UpdateHistoryObj(
                        'payments',
                        Payment._id,
                        previousData,
                        "Edit User Payments Details"
                    );
                    updateHistoriesRepo.SaveNewUpdateHistoriesInDB(updateHistoryDoc);
                };
                res.status(200).json({ status: true, message: "User Payments Updated" });
            }

        }).catch(err => {
            console.log(err)
            res.status(500).json({ status: false, error: err });
        });
}

exports.RemovePaymentDetails = (req, res) => {
    const { PaymentID, UserID } = req.body;
    let query = { _id: PaymentID, UserID: UserID };

    PaymentRepo.FindPaymentFromDB(true, query)
        .then(async (Payment) => {
            if (!Payment) {
                res.status(200).json({ status: true, message: "Payment Doc Not Found" });
                return;
            }
            else {
                let previousData = Payment;
                PaymentRepo.DeletePaymentInDB(query)
                    .then(async () => {
                        if (previousData) {
                            var updateHistoryDoc = new UpdateHistoryObj(
                                'payments',
                                Payment._id,
                                previousData,
                                "Delete User Payments Details"
                            );
                            updateHistoriesRepo.SaveNewUpdateHistoriesInDB(updateHistoryDoc);
                        };
                        res.status(200).json({ status: true, message: "User Payments Deleted" });

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