var express = require('express');
var router = express.Router();
var PaymentController = require("../controllers/payment.controller");
const checkAuth = require('../middlewares/checkAuth').authMiddleware;



router.post("/savePaymentDetails", checkAuth, PaymentController.savePaymentDetails);
router.post("/updatePaymentDetails", checkAuth, PaymentController.updatePaymentDetails);
router.post("/RemovePaymentDetails", checkAuth, PaymentController.RemovePaymentDetails);


module.exports = router;
