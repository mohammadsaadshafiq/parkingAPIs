const CustomizationRepo = require("../repositories/customization.repostory");

exports.saveCustomize = (req, res) => {
    let Data = req.body;
    CustomizationRepo.SaveNewCustomizationInDB(Data).then((success) => {
        res.status(200).json({ status: true, Data: success });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}
exports.getCustomize = (req, res) => {
    const {Category} = req.body;
    let query = {};
    let isSingle = null;
    if (Array.isArray(Category) ){
        isSingle = false;
        query= {Category :{$in:Category}};
    }
    else{
        isSingle = true;
        query= {Category :Category};
    }
    CustomizationRepo.FindCustomizationFromDB(isSingle,query).then((success) => {
        res.status(200).json({ status: true, Data: success });
    }).catch(err => {
        res.status(500).json({ status: false, error: err })
    });
}