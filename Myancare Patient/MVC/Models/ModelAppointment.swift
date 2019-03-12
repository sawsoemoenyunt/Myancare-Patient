//
//  ModelAppointment.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ModelAppointment: NSObject {
    
    var doctorID: String = ""
    var slotID: String = ""
    var appointmentType: String = ""
    var issueDate : String = ""
    var appointmentReason: String = ""
    var doctorName : String = ""
    var serviceFees : String = ""
    var scheduleDate : String = ""
    var isReschedule : Bool = false
    var appointmentID : String = ""
    var service_tax : String = ""
    var total_consultant_fees : String = ""
    
    override init() {
        
    }
    
    func getAppointmentDictionary() -> [String : String] {
        
        let dictAppointment = [
            "doctor" : doctorID,
            "slot" : slotID,
            "type" : appointmentType,
            "date_of_issue" : issueDate,
            "reason"  : appointmentReason,
            "service_fees"  : service_tax,
            "total_appointment_fees"  : total_consultant_fees
        ]
        
        return dictAppointment
    }
    
    func getAppointmentChatDictionary() -> [String : Any] {
        
        var appointmentPrice = serviceFees
        
        appointmentPrice = appointmentPrice.replacingOccurrences(of: " ", with: "")
        appointmentPrice = appointmentPrice.replacingOccurrences(of: "Kyat".localized(), with: "")
        appointmentPrice = appointmentPrice.replacingOccurrences(of: "Coin".localized(), with: "")
        
        let appointmentFees = Float(appointmentPrice)!
        
        let dictAppointment = [
            "doctor" : doctorID,
            "type" : appointmentType,
            "date_of_issue" : issueDate,
            "amount" : appointmentFees,
            "service_fees"  : service_tax,
            "total_appointment_fees"  : total_consultant_fees
            ] as [String : Any]
        
        return dictAppointment
    }
    
    func getRescheduleAppointmentDictionary() -> [String : String] {
        
        let dictAppointment = [
            "appointment_id" : appointmentID,
            "new_slot" : slotID,
            "remarks" : appointmentReason
        ]
        
        return dictAppointment
    }
}
