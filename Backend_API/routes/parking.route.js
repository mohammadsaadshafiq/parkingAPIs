var express = require('express');
var router = express.Router();
var ParkingController = require("../controllers/parking.controller");
const checkAuth = require('../middlewares/checkAuth').authMiddleware;



router.get("/findParkingLocations/:location?", checkAuth, ParkingController.findParkingLocation);
router.post("/reserveParkingSpot", checkAuth, ParkingController.reserveParkingSpot);
router.post("/cancelParkingReservation", checkAuth, ParkingController.cancelParkingReservation);
router.post("/completeParkingReservation", checkAuth, ParkingController.completeParkingReservation);
router.post("/getParkingHistories", checkAuth, ParkingController.getParkingHistories);
router.post("/ExtendReserveParkingSpot", checkAuth, ParkingController.ExtendReserveParkingSpot);




module.exports = router;
