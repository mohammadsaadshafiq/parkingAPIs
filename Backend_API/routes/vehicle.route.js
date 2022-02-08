var express = require('express');
var router = express.Router();
var VehicleController = require("../controllers/vehicle.controller");
const checkAuth = require('../middlewares/checkAuth').authMiddleware;



router.post("/saveVehicle", checkAuth, VehicleController.saveVehicle);
router.post("/updateVehicle", checkAuth, VehicleController.updateVehicle);
router.post("/removeVehicleDetails", checkAuth, VehicleController.removeVehicleDetails);


module.exports = router;