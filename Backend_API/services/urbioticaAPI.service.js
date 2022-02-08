
let q = require("q");
const CustomizationRepo = require("../repositories/customization.repostory");
const axios = require("axios");
const {calculateTokenExpirationTime} = require("../utils/utils");

exports.getDataFromUrbioticaAPI = (axios_parkingData_obj, axios_token_obj) => {
    var deferred = q.defer();
    let Category = "Token Expiration Time";
    let currentTime = new Date();

    CustomizationRepo.FindCustomizationFromDB(true, { Category: Category }).then((success) => {
        if (success) {
            if (success.TokenExpirationTime < currentTime) {
                axios(axios_token_obj).then(async (axios_token_res) => {
                    let update_obj = { $set: { Token: axios_token_res.data, TokenExpirationTime: calculateTokenExpirationTime(1) } }
                    CustomizationRepo.UpdateCustomizationInDB({ Category: Category }, update_obj);
                    axios_parkingData_obj["headers"]['IDENTITY_KEY'] = axios_token_res.data;

                    axios(axios_parkingData_obj).then(axios_paring_res => {
                        deferred.resolve(axios_paring_res.data);
                    }).catch(err => {
                        deferred.reject(err);
                    });
                }).catch(err => {
                    deferred.reject(err);
                });
            }
            else {
                axios_parkingData_obj["headers"]['IDENTITY_KEY'] = success.Token;
                axios(axios_parkingData_obj).then(axios_paring_res => {
                    deferred.resolve(axios_paring_res.data);
                }).catch(err => {
                    deferred.reject(err);
                });
            }
        }
        else {
            axios(axios_token_obj).then(axios_token_res => {
                axios_parkingData_obj["headers"]['IDENTITY_KEY'] = axios_token_res.data;
                let obj = { Category: Category, TokenExpirationTime: calculateTokenExpirationTime(1), Token: axios_token_res.data }
                CustomizationRepo.SaveNewCustomizationInDB(obj);
                axios(axios_parkingData_obj).then(axios_paring_res => {
                    deferred.resolve(axios_paring_res.data);
                }).catch(err => {
                    deferred.reject(err);
                });
            }).catch(err => {
                deferred.reject(err);
            });
        }
    }).catch(err => {
        deferred.reject(err);
    });

    return deferred.promise;
}