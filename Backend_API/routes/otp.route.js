var express = require('express');
var router = express.Router();
var OTPController = require("../controllers/otp.controller");
const checkAuth = require('../middlewares/checkAuth').authMiddleware;



router.post("/sendOTPCode", OTPController.sendOTPCode);
router.post("/verifyOTPCode", OTPController.verifyOTPCode);


module.exports = router;
