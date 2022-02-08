
const { generateOTP, calculateOTPExpirationTime } = require("../utils/otp.util");
const UserRepo = require("../repositories/user.repository");
const OTPRepo = require("../repositories/otp.repository");
const checkAuth = require("../middlewares/checkAuth");
const { otp_Actions ,getOTPMessage} = require("../utils/otp.util");
var smsService = require('../services/sms.service');


exports.sendOTPCode = async (req, res) => {
    try {
        const { Action, MobileNumber } = req.body;

        let otp_query = { MobileNumber: MobileNumber, Action: Action , Verified: { $exists: false } };
        let OTP_Details = {
            OTP: generateOTP(6),
            Expiration_time: calculateOTPExpirationTime(),
            Action: Action,
            MobileNumber: MobileNumber
        }
        const otp = await OTPRepo.FindOTPFromDB(true, otp_query);
        let OTPMessage = getOTPMessage(OTP_Details.OTP);
        if (!otp) {
            await OTPRepo.SaveNewOTPInDB(OTP_Details);
            smsService.sendTextMessege(OTPMessage,MobileNumber);
            res.status(200).json({ status: true, OTP_Details: OTP_Details, message: "OTP sended to mobile number" });
        }
        else {
            let OTP_obj = { $set: OTP_Details };
            await OTPRepo.UpdateOTPInDB(otp_query, OTP_obj);
            smsService.sendTextMessege(OTPMessage,MobileNumber);
            res.status(200).json({ status: true, OTP_Details: OTP_Details, message: "OTP sended to mobile number" });
        }
    } catch (error) {
        res.status(500).json({ status: false, error: error });
    }
};


exports.verifyOTPCode = async (req, res) => {
    try {
        const { otp, Action, MobileNumber } = req.body;
        let OTP_obj = {};
        let otp_query = { MobileNumber: MobileNumber, Action: Action, Verified: { $exists: false }, OTP: otp };
        

        const OTP_data = await OTPRepo.FindOTPFromDB(true, otp_query);
        if (!OTP_data) {
            res.status(500).json({ status: false, message: "Incorrect OTP" });
            return;
        }

        OTP_obj = { $set: { "Verified": true } };

        await OTPRepo.UpdateOTPInDB(otp_query, OTP_obj);

        res.status(200).json({
            status: true,
            message: "OTP verified successfully"
        });

    } catch (error) {
        res.status(500).json({ status: false, error: error });
    }
}