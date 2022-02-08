var express = require('express');
var router = express.Router();
var userController = require("../controllers/user.controller");
const checkAuth = require('../middlewares/checkAuth').authMiddleware;




router.post("/login", userController.login);
router.post("/createUser", userController.createUser);
router.post('/forgotPassword', userController.forgotPassword);
router.post('/changePassword', checkAuth, userController.changePassword)
router.post('/getUserProfile', checkAuth, userController.getUserProfile)
router.post('/updateUserProfile', checkAuth, userController.updateUserProfile)
router.post('/addUserResidentialOrOfficeAddress', checkAuth, userController.addUserResidentialOrOfficeAddress)


// Facebooh Login
router.get("/auth/facebook", userController.loginFacebook)
router.get('/facebook/callback', userController.facebookCallback)

module.exports = router;
