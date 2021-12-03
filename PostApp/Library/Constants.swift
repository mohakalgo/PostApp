
//
//  Constants.swift
//  Politis
//
//  Created by Dixit Rathod on 06/12/19.
//  Copyright © 2019 Dixit Rathod. All rights reserved.
//

import UIKit
import Foundation

var selectLanguage = "en"
var userType = "admin"
//var profileData : SignInModel.Result!

struct errorMsg {
    static let emailFormate = "Please enter valid email address"
}

struct EndPoints {
    
    static let login = "login"
    static let verify = "otp_verify"
    static let emailVerify = "email_verify"
    static let  commonApi = "common_api"
    static let  city = "city"
    static let  settings = "settings"
    static let  user_update = "user_update"
    static let  settings_update = "settings_update"
    static let  tournaments = "tournaments"
    static let  Enrollment_count = "enrollment_count"
    static let  edit_user = "edit_user"

    static let upcoming = "upcoming"
    static let history = "history"

    
}

var cruiseID = ""

extension String {
    
    var localized: String {
        if L102Language.currentAppleLanguage() == "ar" {
            return NSLocalizedString(self, comment: self)
        }
        else{
            return self
        }
    }
}
