//
//  API.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

let baseURLString = "http://192.168.1.131:5000/api/"

//MARK:- Protocol Endpoint path
protocol ApiEndpoint {
    var path :URL {get}
}

//MARK:- Enum Endpoint Final Path
enum EndPoints : ApiEndpoint {
    
    case checkfb(String)
    case checkmobile(String)
    
    var path: URL
    {
        switch self {
            case .checkfb(let id):
                return URL(string: String(baseURLString+"patients/checkfb?\(id)"))!
        case .checkmobile(let id):
            return URL(string: String(baseURLString+"patients/checkmobile?\(id)"))!
        }
    }
}
