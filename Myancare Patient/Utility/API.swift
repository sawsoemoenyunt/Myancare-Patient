//
//  API.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

let baseURLString = "http://192.168.1.128:5000/api/"

//MARK:- Protocol Endpoint path
protocol ApiEndpoint {
    var path :URL {get}
}

//MARK:- Enum Endpoint Final Path
enum EndPoints : ApiEndpoint {
    
    case checkfb(String)
    case checkmobile(String)
    case articles
    case imagesProfile
    case patientCreate
    case updateDeviceToken(String)
    case get_transactions(Int,Int)
    case getDoctors
    case getRecommandDoctors
    case getFavoriteDoctors
    case getExchangeRatesByPaymentGateway(String)
    case getDoctorData(String)
    case getDoctorFilter(String)
    case getSpecializations
    case getDocotrBySpecialiation(String)
    case getNotifications(Int,Int) //limit, skip
    
    var path: URL
    {
        switch self {
        case .checkfb(let id):
            return URL(string: String(baseURLString+"patients/checkfb?fb_acc=\(id)"))!
        case .checkmobile(let id):
            return URL(string: String(baseURLString+"patients/checkmobile?mobile=\(id)"))!
        case .articles:
            return URL(string: String(baseURLString+"patients/checkmobile?article"))!
        case .imagesProfile:
            return URL(string: String(baseURLString+"images/profile"))!
        case .patientCreate:
            return URL(string: String(baseURLString+"patients/create"))!
        case .updateDeviceToken(let token):
            return URL(string: String(baseURLString+"patients/update_device/\(token)"))!
        case .get_transactions(let skip, let limit):
            return URL(string: String(baseURLString+"transactions/patient?skip=\(skip)&limit=\(limit)"))!
        case .getDoctors:
            return URL(string: String(baseURLString+"doctors"))!
        case .getExchangeRatesByPaymentGateway(let gateway):
            return URL(string: String(baseURLString+"exchange-rates/\(gateway)"))!
        case .getDoctorData(let doctorID):
            return URL(string: String(baseURLString+"doctors/\(doctorID)"))!
        case .getRecommandDoctors:
            return URL(string: String(baseURLString+"doctors?recommand=true"))!
        case .getFavoriteDoctors:
            return URL(string: String(baseURLString+"doctors?favorite=true"))!
        case .getDoctorFilter(let nameString):
            return URL(string: String(baseURLString+"doctors?name=\(nameString)"))!
        case .getSpecializations:
            return URL(string: String(baseURLString+"specializations"))!
        case .getDocotrBySpecialiation(let specID):
            return URL(string: String(baseURLString+"doctors?specialization=\(specID)"))!
        case .getNotifications(let limit, let skip):
            return URL(string: String(baseURLString+"notifications?limit=\(limit)&skip=\(skip)"))!
        }
    }
}
