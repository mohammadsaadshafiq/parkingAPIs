var express = require('express');
var router = express.Router();
var CustomizationController = require("../controllers/customization.controller");
const checkAuth = require('../middlewares/checkAuth').authMiddleware;


router.post("/saveCustomize", checkAuth, CustomizationController.saveCustomize);
router.get("/getCustomize", checkAuth, CustomizationController.getCustomize);


module.exports = router;
