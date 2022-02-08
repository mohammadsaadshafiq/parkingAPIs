'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const sms_history = new Schema({    
    Status: String,
    MobileNumber: String,
    Content: String,
    UserID: { type: Schema.ObjectId },
    SMS_GateWay_Response: {}
}, { timestamps: true });
  
exports.Model = mongoose.model('sms_history', sms_history);