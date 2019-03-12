//
//  AppointmentModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class AppointmentModel
{
    var appointmentID : String = ""
    var type : String = ""
    var reason : String = ""
    var date_of_issue : String = ""
    var amount : String = ""
    var service_fees : String = ""
    var total_appointment_fees : String = ""
    var slotStartTime : String = ""
    var slotEndTime : String = ""
    var status : String = ""
    var remarks : String = ""
    var booking_status : String = ""
    var order_number : String = ""
    
    var reschedule : Bool = false
    
    var patient_dict : [String : Any] = [:]
    var doctor_dict : [String : Any] = [:]
    var slot_dict: [String : Any] = [:]
    
    var rejectReason : String = ""
    
    var formatted_date : String = ""
    var formatted_str : String = ""
    
    init()
    {
        appointmentID = ""
        reason = ""
        type = ""
        date_of_issue = ""
        amount = ""
        slotStartTime = ""
        slotEndTime = ""
        status = ""
        remarks = ""
        booking_status = ""
        order_number = ""
        
        rejectReason = ""
        
        reschedule = false
        
        patient_dict = [:]
        doctor_dict = [:]
        slot_dict = [:]
    }
    
    deinit
    {
        print("Appointment Model deinit")
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        if let id = dictionary["id"] as? String
        {
            appointmentID = id
        }
        
        if let reason1 = dictionary["reason"] as? String
        {
            reason = reason1
        }
        
        if let type1 = dictionary["type"] as? String
        {
            type = type1
        }
        
        if let date_of_issue1 = dictionary["date_of_issue"] as? String
        {
            date_of_issue = date_of_issue1
        }
        
        if let formatted_date1 = dictionary["formatted_date"] as? String
        {
            formatted_date = formatted_date1
        }
        
        if let formatted_str1 = dictionary["formatted_str"] as? String
        {
            formatted_str = formatted_str1
        }
        
        if let amount1 = dictionary["amount"] as? Int
        {
            amount = String(amount1)
            amount = "\(amount) " + "Coin".localized()
        }
        
        if let total_appointment_fees1 = dictionary["total_appointment_fees"] as? Double
        {
            let total_appointment_fees2 = NSString(format : "%.2f", total_appointment_fees1)
            total_appointment_fees = String(total_appointment_fees2)
            total_appointment_fees = "\(total_appointment_fees) " + "Coin".localized()
        }
        
        if let service_fees1 = dictionary["service_fees"] as? Double
        {
            let service_fees2 = NSString(format : "%.2f", service_fees1)
            service_fees = String(service_fees2)
            service_fees = "\(service_fees) " + "Coin".localized()
        }
        
        if let slotStartTime1 = dictionary["slotStartTime"] as? Double
        {
            slotStartTime = String(slotStartTime1)
            
            if (slotStartTime.count) > 10
            {
                let index2 = (slotStartTime.index((slotStartTime.startIndex), offsetBy: 10))
                let indexStart = index2
                
                let indexEnd = (slotStartTime.endIndex)
                
                slotStartTime.removeSubrange(indexStart ..< indexEnd)
            }
        }
        
        if let slotEndTime1 = dictionary["slotEndTime"] as? Int
        {
            slotEndTime = String(slotEndTime1)
            
            if (slotEndTime.count) > 10
            {
                let index2 = (slotEndTime.index((slotEndTime.startIndex), offsetBy: 10))
                let indexStart = index2
                
                let indexEnd = (slotEndTime.endIndex)
                
                slotEndTime.removeSubrange(indexStart ..< indexEnd)
            }
        }
        
        if let status1 = dictionary["status"] as? Int
        {
            status = String(status1)
        }
        
        if let remarks1 = dictionary["remarks"] as? String
        {
            remarks = remarks1
        }
        
        if let booking_status1 = dictionary["booking_status"] as? String
        {
            booking_status = booking_status1
        }
        
        if let order_number1 = dictionary["order_number"] as? String
        {
            order_number = order_number1
        }
        
        if let reschedule1 = dictionary["reschedule"] as? Bool
        {
            reschedule = reschedule1
        }
        
        if let patient_dict1 = dictionary["patient"] as? [String:Any]
        {
            patient_dict = patient_dict1
        }
        
        if let doctor_dict1 = dictionary["doctor_details"] as? [String:Any]
        {
            doctor_dict = doctor_dict1
        }
        
        if let slot_dict1 = dictionary["slot"] as? [String:Any]
        {
            slot_dict = slot_dict1
        }
    }
    
    func getRejectAppointmentParametersdata () -> [String : String]
    {
        let dictRejectAppointment = [
            "appointment_id" : appointmentID,
            "remarks" : rejectReason
        ]
        
        return dictRejectAppointment
    }
    
    func getAcceptAppointmentParametersdata () -> [String : String]
    {
        if type == "chat"
        {
            let dictAcceptAppointment = [
                "appointment_id" : appointmentID
            ]
            
            return dictAcceptAppointment
        }
        else
        {
            let dictAcceptAppointment = [
                "appointment_id" : appointmentID,
                "remarks" : remarks,
                "slot" : slot_dict["id"] as? String
            ]
            
            return dictAcceptAppointment as! [String : String]
        }
    }
    
    func getAppoinrmentRemarkString() -> String
    {
        var remark_string = ""
        
        let slotId = slot_dict["id"] as? String
        
        let bookingArr = doctor_dict["bookings"] as! [[String : Any]]
        
        for dict in bookingArr
        {
            if let dict_id = dict["slot"] as? String
            {
                if slotId == dict_id
                {
                    guard dict["remarks"] != nil else {
                        remark_string = ""
                        return remark_string
                    }
                    
                    if (dict["remarks"] as? NSNull) != nil
                    {
                        remark_string = ""
                    }
                    else
                    {
                        remark_string = dict["remarks"] as! String
                    }
                }
            }
        }
        
        return remark_string
    }
    
    func getAppoinrmentReasonString() -> String
    {
        var reason_string = ""
        if type == "chat"
        {
            reason_string = "NA".localized()
        }
        else
        {
            let slotId = slot_dict["id"] as? String
            
            let bookingArr = doctor_dict["bookings"] as! [[String : Any]]
            
            for dict in bookingArr
            {
                if let dict_id = dict["slot"] as? String
                {
                    if slotId == dict_id
                    {
                        reason_string = dict["reason"] as! String
                    }
                }
            }
        }
        
        return reason_string
    }
}
