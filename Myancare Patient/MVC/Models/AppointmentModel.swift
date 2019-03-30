//
//  AppointmentModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class AppointmentModel {
    
    var createdAt : String?
    var updatedAt : String?
    var doctor : NSDictionary?
    var patient : NSDictionary?
    var type : String?
    var date_of_issue : NSDictionary?
    var amount : Int?
    var service_fees : Int?
    var total_appointment_fees : Int?
    var slotStartTime : NSDictionary?
    var slotEndTime : NSDictionary?
    var date_of_issue_utc : NSDictionary?
    var remarks : String?
    var reason : String?
    var booking_status : String?
    
    init() {
        createdAt = ""
        updatedAt = ""
        doctor = NSDictionary()
        patient = NSDictionary()
        type = ""
        date_of_issue = NSDictionary()
        amount = 0
        service_fees = 0
        total_appointment_fees = 0
        slotStartTime = NSDictionary()
        slotEndTime = NSDictionary()
        date_of_issue_utc = NSDictionary()
        remarks = ""
        reason = ""
        booking_status = ""
    }
    
    func updateModleUsingDict(_ dict:[String:Any]){
        if let createdAt1 = dict["createdAt"] as? String{
            createdAt = createdAt1
        }
        
        if let updatedAt1 = dict["updatedAt"] as? String{
            updatedAt = updatedAt1
        }
        
        if let doctor1 = dict["doctor"] as? NSDictionary{
            doctor = doctor1
        }
        
        if let patient1 = dict["patient"] as? NSDictionary{
            patient = patient1
        }
        
        if let type1 = dict["type"] as? String{
            type = type1
        }
        
        if let date_of_issue1 = dict["date_of_issue"] as? NSDictionary{
            date_of_issue = date_of_issue1
        }
        
        if let amount1 = dict["amount"] as? Int{
            amount = amount1
        }
        
        if let service_fees1 = dict["service_fees"] as? Int{
            service_fees = service_fees1
        }
        
        if let total_appointment_fees1 = dict["total_appointment_fees"] as? Int{
            total_appointment_fees = total_appointment_fees1
        }
        
        if let slotStartTime1 = dict["slotStartTime"] as? NSDictionary{
            slotStartTime = slotStartTime1
        }
        
        if let slotEndTime1 = dict["slotEndTime"] as? NSDictionary{
            slotEndTime = slotEndTime1
        }
        
        if let date_of_issue_utc1 = dict["date_of_issue_utc"] as? NSDictionary{
            date_of_issue_utc = date_of_issue_utc1
        }
        
        if let remarks1 = dict["remarks"] as? String{
            remarks = remarks1
        }
        
        if let reason1 = dict["reason"] as? String{
            reason = reason1
        }
        
        if let booking_status1 = dict["booking_status"] as? String{
            booking_status = booking_status1
        }
    }
}
