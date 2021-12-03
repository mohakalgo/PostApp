//
//  ApiCalls.swift
//  ECODIET
//
//  Created by Mohak Parmar on 26/09/21.
//

import UIKit

class ApiCalls: NSObject {
    
    // Mark: - get terms and conditions
    
    //MARK:- Post login Api
    class func sentOtp(countryCode:String, mobile:String, device_token:String,uuid:String, platform:String, handler : @escaping (Bool?, LoginModel?) -> Void) {
        var dict : [String: Any] = [:]
        dict["contact_number"] = mobile // countryCode + mobile
        dict["device_token"] = device_token
        dict["uuid"] = uuid
        dict["platform"] = platform
        
        WebServiceHandler().requestWith(method: .post, endPoint: EndPoints.login, loader:true, params: dict, model: LoginModel.self, success: { (response) in
            guard let data = response as? LoginModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- Post otp_verify Api
    class func otpVification(countryCode:String, mobile:String, otp:String, handler : @escaping (Bool?, OtpVerifyModel?) -> Void) {
        var dict : [String: Any] = [:]
        dict["contact_number"] = mobile // countryCode + mobile
        dict["otp"] = otp
        WebServiceHandler().requestWith(method: .post, endPoint: EndPoints.verify, loader:true, params: dict, model: OtpVerifyModel.self, success: { (response) in
            guard let data = response as? OtpVerifyModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- Post email_verify Api
    class func emailVerification(email:String, handler : @escaping (Bool?, EmailVerifyModel?) -> Void) {
        var dict : [String: Any] = [:]
        dict["email"] = email
        
        WebServiceHandler().requestWith(method: .post, endPoint: EndPoints.emailVerify, loader:true, params: dict, model: EmailVerifyModel.self, success: { (response) in
            guard let data = response as? EmailVerifyModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                handler(true, data)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- get common_api
    class func commonApi( handler : @escaping (Bool?, CountryCommonModel?) -> Void)  {
        let dict : [String : Any] = [:]
        
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.commonApi, loader:true, params: dict, model: CountryCommonModel.self, success: { (response) in
            guard let data = response as? CountryCommonModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    // Post   city
    class func getCity(countryId:Int, handler : @escaping (Bool?, CityModel?) -> Void) {
        let dict : [String: Any] = [:]
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.city + "?country_id=\(countryId)", loader:true, params: dict, model: CityModel.self, success: { (response) in
            guard let data = response as? CityModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- Post Reg
    class func registerUser(first_name:String, last_name:String, nick_name:String, village:String, email:String, dob:String, country_id:Int,  city_id:Int,  gender:Int, position_id:Int, image : UIImage?, is_enroll:Bool, handler : @escaping (Bool?, CommonModel?) -> Void) {
        var dict : [String: Any] = [:]
        dict["first_name"] = first_name
        dict["last_name"] = last_name
        dict["nick_name"] = nick_name
        dict["village"] = village
        dict["email"] = email
        dict["dob"] = dob
        dict["country_id"] = country_id
        dict["city_id"] = city_id
        dict["gender"] = gender
        dict["position_id"] = position_id
        dict["is_enroll"] = is_enroll
        if let img = image {
            dict["image"] = img.jpegData(compressionQuality: 0.5)
        }
        
        WebServiceHandler().requstWithFormdata(Method: .post, Action:  EndPoints.user_update, ImageParameters: dict, type: CommonModel.self) { (response) in
            guard let data = response as? CommonModel else {
                return
            }
                        if data.status ?? 0 == 1 {
                            handler(true, data)
                    } else {
                        AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                        handler(false, nil)
                    }
        } failure: { obj in
//               CommonClass().showResponseError(errorCode: errorCode)
        }
    }
    
    //MARK:- post Setting Update
    class func settingUpdate(enrol_reminder:Bool, last_day_enrol_reminder:Bool, new_league_reminder:Bool, handler : @escaping (Bool?, UserSettingUpdateModel?) -> Void) {
        var dict : [String: Any] = [:]
        dict["enrol_reminder"] = enrol_reminder
        dict["last_day_enrol_reminder"] = last_day_enrol_reminder
        dict["new_league_reminder"] = new_league_reminder
        
        WebServiceHandler().requestWith(method: .post, endPoint: EndPoints.settings_update, loader:true, params: dict, model: UserSettingUpdateModel.self, success: { (response) in
            guard let data = response as? UserSettingUpdateModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- get settingUser
    class func settingUser( handler : @escaping (Bool?, UserSettingModel?) -> Void)  {
        let dict : [String : Any] = [:]
        
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.settings, loader:true, params: dict, model: UserSettingModel.self, success: { (response) in
            guard let data = response as? UserSettingModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- Post tournaments Enroll Create
    class func tournamentsEnrollCreate(tournaments_id:Int, handler : @escaping (Bool?, EnrollModel?) -> Void) {
        var dict : [String: Any] = [:]
        dict["tournaments_id"] = tournaments_id
        
        WebServiceHandler().requestWith(method: .post, endPoint: EndPoints.tournaments, loader:true, params: dict, model: EnrollModel.self, success: { (response) in
            guard let data = response as? EnrollModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- get tournamentShow_api
    class func tournamentShow( handler : @escaping (Bool?, TournamentShowModel?) -> Void)  {
        let dict : [String : Any] = [:]
        
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.tournaments, loader:true, params: dict, model: TournamentShowModel.self, success: { (response) in
            guard let data = response as? TournamentShowModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- get Upcoming
    class func upcoming( handler : @escaping (Bool?, TournamentShowModel?) -> Void)  {
        let dict : [String : Any] = [:]
        
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.upcoming, loader:true, params: dict, model: TournamentShowModel.self, success: { (response) in
            guard let data = response as? TournamentShowModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- get history
    class func history( handler : @escaping (Bool?, TournamentShowModel?) -> Void)  {
        let dict : [String : Any] = [:]
        
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.history, loader:true, params: dict, model: TournamentShowModel.self, success: { (response) in
            guard let data = response as? TournamentShowModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- get enrollment_count
    class func enrollmentCount( handler : @escaping (Bool?, EnrolmentCountModel?) -> Void)  {
        let dict : [String : Any] = [:]
        
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.Enrollment_count, loader:true, params: dict, model: EnrolmentCountModel.self, success: { (response) in
            guard let data = response as? EnrolmentCountModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    //MARK:- get user
    class func userInfo( handler : @escaping (Bool?, UserInfoModel?) -> Void)  {
        let dict : [String : Any] = [:]
        
        WebServiceHandler().requestWith(method: .get, endPoint: EndPoints.edit_user, loader:true, params: dict, model: UserInfoModel.self, success: { (response) in
            guard let data = response as? UserInfoModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
    class func tournamentDetail(id:Int, handler : @escaping (Bool?, TournamentDetailShowModel?) -> Void)  {
        let dict : [String : Any] = [:]

        
        WebServiceHandler().requestWith( method: .get, endPoint: EndPoints.tournaments+"/"+"\(id)", loader:true, params: dict, model: TournamentDetailShowModel.self, success: { (response) in
            guard let data = response as? TournamentDetailShowModel else {
                return
            }
            if data.status ?? 0 == 1 {
                handler(true, data)
            } else {
                AppUtil().showAlertPopup(text: data.message ?? "", type: .warning)
                handler(false, nil)
            }
        }, failure: { (dict, errorCode) in
            CommonClass().showResponseError(errorCode: errorCode)
        })
    }
    
}
