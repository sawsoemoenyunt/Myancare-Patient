//
//  API.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

let baseURLString = "http://192.168.1.105:5000/api/"

//MARK:- Protocol Endpoint path
protocol ApiEndpoint {
    var path :URL {get}
}

//MARK:- Enum Endpoint Final Path
enum EndPoints : ApiEndpoint {
    
    case checkfb(String)
    case checkmobile(String)
    case articles
    case patientCreate
    case updateDeviceToken(String)
    
    var path: URL
    {
        switch self {
            case .checkfb(let id):
                return URL(string: String(baseURLString+"patients/checkfb?fb_acc=\(id)"))!
            case .checkmobile(let id):
                return URL(string: String(baseURLString+"patients/checkmobile?mobile=\(id)"))!
            case .articles:
                return URL(string: String(baseURLString+"patients/checkmobile?article"))!
            case .patientCreate:
                return URL(string: String(baseURLString+"patients/create"))!
        case .updateDeviceToken(let token):
            return URL(string: String(baseURLString+"patients/update_device/\(token)"))!
        }
    }
}
