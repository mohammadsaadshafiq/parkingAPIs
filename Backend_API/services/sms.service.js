var smsHistoryModel = require("../models/smsHistories.model").Model;

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = require("twilio")(accountSid, authToken);


function sendTextMessege(messege, userNumber) {
  let body = messege;
  client.messages
    .create({
      body: body,
      from: process.env.phoneNumber,
      to: userNumber
    }).then(success => {
      let Obj = {
        Status: success.status,
        MobileNumber: userNumber,
        Content: body,
        SMS_GateWay_Response: JSON.stringify(success),
      }
      let smsHistories = new smsHistoryModel(Obj);
      smsHistories.save().then(success => {
      }).catch(err => {
        console.log(err);
      });
    })
}

module.exports = { sendTextMessege };


