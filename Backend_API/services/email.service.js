const sgMail = require('@sendgrid/mail')
var emailHistoryModel = require("../models/emailHistories.model").Model;

sgMail.setApiKey(process.env.SENDGRID_API_KEY)

function sendEmail(userData, obj) {
  let html = `<h4><strong>Dear `+ userData.FirstName + " " +  userData.LastName + `,` + obj.message + `</strong></h4><h4><strong>Thank you,</strong></h4>
    <h3><strong>TASMU Support Team</strong></h3>`;
  var message = {
    to: userData.EmailID,
    from: process.env.SENDGRID_EMAIL,
    subject: obj.subject,
    html: html,
  }
  sgMail.send(message).then(success => {
    let Obj = {
      EmailID: userData.EmailID,
      EMailMessage: html,
      From: process.env.SENDGRID_EMAIL,
      Subject: obj.subject,
      TextContent: obj.message,
      UserID: userData._id
    }
    let emailHistories = new emailHistoryModel(Obj);
    emailHistories.save();
  }).catch(err => {
    console.log(err);
  });
}

module.exports = { sendEmail };