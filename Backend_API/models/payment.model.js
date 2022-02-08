const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const ObjectId = Schema.ObjectId;

const PaymentSchema = new Schema({
    PaymentMethod: String,
    UserID: { type: Schema.ObjectId },
    CardName: String,
    CardNumber: String,
    CardExpiryDate: String,
    CardCVV: String
}, { timestamps: true });

exports.getPaymentModel = mongoose.model("Payments", PaymentSchema);
