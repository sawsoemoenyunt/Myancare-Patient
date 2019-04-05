//
//  API.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

let baseURLString = "http://159.65.10.176/api/"
//let baseURLString = "http://192.168.0.253:5000/api/"

//MARK:- Protocol Endpoint path
protocol ApiEndpoint {
    var path :URL {get}
}

//MARK:- Enum Endpoint Final Path
enum EndPoints : ApiEndpoint {
    
    case getPatient
    case checkfb(String)
    case checkmobile(String)
    case articles
    case imagesProfile
    case imagesUpload
    case patientCreate
    case updateDeviceToken
    case get_transactions(Int,Int)
    case getDoctors
    case getRecommandDoctors
    case getFavoriteDoctors
    case getPaymentMethods
    case getExchangeRatesByPaymentGateway(String)
    case getDoctorData(String)
    case getDoctorFilter(String)
    case getSpecializations
    case getDocotrBySpecialiation(String)
    case getNotifications(Int,Int, String) //limit, skip, lan
    case getArticles(Int,Int) //skip, limit
    case getArticleByID(String)
    case getAppointments(String,Int,Int) // skip ,limit
    case getReminders(Int,Int)
    case getRemindersToday(Int,Int)
    case deleteReminderByID(String)
    case getOperationHours(String,String) //date, docID
    case getMedicalRecordBooks(Int,Int) //skip, limit
    case appointmentCreate
    case getAppointment // for home view
    case getServiceFees(Int) //amount
    case addSheet
    case getSheet(String)
    case addBookPermission
    case transactionsRequest
    case setFavourites //docotor favourite
    case deleteFavourites(String) //docotor favourite
    
    var path: URL
    {
        switch self {
        case .getPatient:
            return URL(string: String(baseURLString+"patients"))!
        case .checkfb(let id):
            return URL(string: String(baseURLString+"patients/checkfb?fb_acc=\(id)"))!
        case .checkmobile(let id):
            return URL(string: String(baseURLString+"patients/checkmobile?mobile=\(id)"))!
        case .articles:
            return URL(string: String(baseURLString+"patients/checkmobile?article"))!
        case .imagesProfile:
            return URL(string: String(baseURLString+"images/profile"))!
        case .imagesUpload:
            return URL(string: String(baseURLString+"images/upload"))!
        case .patientCreate:
            return URL(string: String(baseURLString+"patients/create"))!
        case .updateDeviceToken:
            return URL(string: String(baseURLString+"patients/update_device"))!
        case .get_transactions(let skip, let limit):
            return URL(string: String(baseURLString+"transactions/patient?skip=\(skip)&limit=\(limit)"))!
        case .getDoctors:
            return URL(string: String(baseURLString+"doctors"))!
        case .getPaymentMethods:
            return URL(string: String(baseURLString+"exchange-rates"))!
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
        case .getNotifications(let limit, let skip, let language):
            return URL(string: String(baseURLString+"notifications?limit=\(limit)&skip=\(skip)&language=\(language)"))!
        case .getArticles(let skip, let limit):
            return URL(string: String(baseURLString+"articles?skip=\(skip)&limit=\(limit)"))!
        case .getArticleByID(let id):
            return URL(string: String(baseURLString+"articles/\(id)"))!
        case .getAppointments(let type, let skip, let limit):
            return URL(string: String(baseURLString+"appointments/\(type)?skip=\(skip)&limit=\(limit)"))!
        case .getReminders(let skip, let limit):
            return URL(string: String(baseURLString+"medical-reminder?skip=\(skip)&limit=\(limit)"))!
        case .getRemindersToday(let skip, let limit):
            return URL(string: String(baseURLString+"medical-reminder/today?skip=\(skip)&limit=\(limit)"))!
        case .deleteReminderByID(let id):
            return URL(string: String(baseURLString+"medical-reminder/\(id)"))!
        case .getOperationHours(let date, let docID):
            return URL(string: String(baseURLString+"operation-hours?date=\(date)&doctor=\(docID)"))!
        case .getMedicalRecordBooks(let skip, let limit):
            return URL(string: String(baseURLString+"medical-record-book?skip=\(skip)&limit=\(limit)"))!
        case .appointmentCreate:
            return URL(string: String(baseURLString+"appointments/create"))!
        case .getServiceFees(let amount):
            return URL(string: String(baseURLString+"service-fees/amount?amount=\(amount)"))!
        case .addSheet:
            return URL(string: String(baseURLString+"medical-record-book/addSheet"))!
        case .getSheet(let recordID):
            return URL(string: String(baseURLString+"medical-record-book/sheet?record_id=\(recordID)"))!
        case .addBookPermission:
            return URL(string: String(baseURLString+"medical-record-book/addBookPermission"))!
        case .getAppointment:
            return URL(string: String(baseURLString+"appointments"))!
        case .transactionsRequest:
            return URL(string: String(baseURLString+"transactions/request"))!
        case .setFavourites:
            return URL(string: String(baseURLString+"favorites"))!
        case .deleteFavourites(let docID):
            return URL(string: String(baseURLString+"favorites/\(docID)"))!
        }
    }
}
