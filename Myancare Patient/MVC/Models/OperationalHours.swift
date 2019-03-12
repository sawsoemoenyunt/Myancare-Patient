//
//  OperationalHours.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

//import Foundation
//
//class ModelOperationalHours
//{
//    var id : String?
//    var date: String?
//    var dateLong: String?
//    var startTime : String?
//    var endTime : String?
//    var booking_status = 0
//
//    init() {
//        id = ""
//        dateLong = ""
//        date = ""
//        startTime = ""
//        endTime = ""
//    }
//
//    deinit {
//        print("ModelOperationalHours Model deinit")
//    }
//
//    func updateOprationalHourModel(usingDictionary dictionary:[String:Any]) -> Void
//    {
//        //print("dictionary = \(dictionary)")
//
//        if let cateID = dictionary["id"] as? String
//        {
//            id = cateID
//        }
//
//        if let dateTimestamp = dictionary["slot_start_time_long"] as? NSInteger
//        {
//            //14/02/2018
//
////            date = UtilityClass.getDateStringFromTimeStamp(timeStamp: String(dateTimestamp), dateFormat: "MM/dd/yyyy") as String
//        }
//
//        if let dateTimestamp1 = dictionary["slot_start_time_long"] as? NSInteger
//        {
//            //14/02/2018
//
////            dateLong = UtilityClass.getDateStringFromTimeStamp(timeStamp: String(dateTimestamp1), dateFormat: "dd MMM") as String
//        }
//
//        if let startDateTime = dictionary["slot_start_time_long"] as? NSInteger
//        {
////            startTime = UtilityClass.getDateStringFromTimeStamp(timeStamp: String(startDateTime), dateFormat: "hh:mm a") as String
//        }
//
//        if let endDateTime = dictionary["slot_end_time_long"] as? NSInteger
//        {
////            endTime = UtilityClass.getDateStringFromTimeStamp(timeStamp: String(endDateTime), dateFormat: "hh:mm a") as String
//        }
//
//        if let booking_status1 = dictionary["booking_status"] as? Int
//        {
//            booking_status = booking_status1
//        }
//    }
//}
//
