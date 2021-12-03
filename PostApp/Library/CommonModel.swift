//
//  CommonModel.swift
//  Waves
//
//  Created by iMac on 07/05/21.
//  Copyright © 2021 Maulik Goyani. All rights reserved.
//

import Foundation
struct CommonModel : Codable {
    
    let data : Datum?
    let meta : Datum?
    let message : String?
    let status : Int?
//    let statusCode : Int?
//    let success : Bool?
    
    struct Datum : Codable {
        
    }
}

