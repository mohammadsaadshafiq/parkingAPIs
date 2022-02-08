const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const ObjectId = Schema.ObjectId;

var UpDateHistoriesSchema = new Schema({
    CollectionName : String,
    DocumentID :ObjectId,
    Updates : {},
    Functionality : String,
}, { timestamps: true });

exports.getUpDateHistoriesModel = mongoose.model("updatehistories", UpDateHistoriesSchema);
