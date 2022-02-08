const otpGenerator = require('otp-generator');

exports.generateOTP = (otp_length) => {
    //let OTP = otpGenerator.generate(otp_length, { digits: true, upperCaseAlphabets: false, specialChars: false });
    var digits = "0123456789";
    let OTP = "";
    for (let i = 0; i < otp_length; i++) {
        OTP += digits[Math.floor(Math.random() * 10)];
    }
    return OTP;
};

exports.calculateOTPExpirationTime = () => {
    var minutesToAdd = 02;
    var currentDate = new Date();
    var futureDate = new Date(currentDate.getTime() + minutesToAdd * 60000);
    return futureDate
}
exports.getOTPMessage = (otpCode) => {
    return `Use verification code: ` + otpCode + ` for authentication. `;
}

let otp_Actions = {
    SIGNUP: "Sign Up",
    FORGOT_PASSWORS: "Forgot Password"
}
exports.otp_Actions = otp_Actions;





