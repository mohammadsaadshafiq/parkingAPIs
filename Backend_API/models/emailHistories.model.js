'use strict';

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const email_history = new Schema({    
    EmailID: String,
    EMailMessage: String,
    From: String,
    Subject: String,
    TextContent: String,
    UserID: { type: Schema.ObjectId }
}, { timestamps: true });
  
exports.Model = mongoose.model('email_history', email_history);