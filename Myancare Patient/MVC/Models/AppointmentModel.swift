//
//  AppointmentModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

enum BookingStatus : Int{
    case PENDING = 0
    case APPROVED = 1
    case REJECTED = 2
    case COMPLETED = 3
    case CANCELED = 4
    case CANCELEDBYSYSTEM = 5
    case CALL_ONCE_SUCCESSFULL = 6
    case CALL_INITIATED = 7
    case DOCTIR_CALL_PATIENT_GOT_ALERTED = 8
    case PATIENT_MISSED_THE_CALL = 9
    case PATIENT_PICKS_THE_CALL = 10
    case PATIENT_REJECTS_THE_CALL = 11
    case DOCTOR_HUNGS_THE_CALL = 12
    case PATIENT_HUNGS_THE_CALL = 13
    case SOCKET_DISCONNECTED_CANCELED_BY_SYSTEM = 14
    case DOCTOR_NOT_REPLY = 15
    case PATIENT_NOT_REPLY = 16
    case RESCHEDULE_BY_DOCTOR = 17
    case RESCHEDULE_BY_PATIENT = 18
}

class AppointmentModel {
    
    var createdAt : String?
    var updatedAt : String?
    var doctor : NSDictionary?
    var patient : NSDictionary?
    var type : String?
    var date_of_issue : String?
    var amount : Int?
    var service_fees : Int?
    var total_appointment_fees : Int?
    var slotStartTime : Int?
    var slotEndTime : Int?
    var date_of_issue_utc : String?
    var remarks : String?
    var reason : String?
    var booking_status  = BookingStatus.PENDING
    
    init() {
        createdAt = ""
        updatedAt = ""
        doctor = NSDictionary()
        patient = NSDictionary()
        type = ""
        date_of_issue = ""
        amount = 0
        service_fees = 0
        total_appointment_fees = 0
        slotStartTime = 0
        slotEndTime = 0
        date_of_issue_utc = ""
        remarks = ""
        reason = ""
        booking_status = BookingStatus.PENDING
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
        
        if let date_of_issue1 = dict["date_of_issue"] as? String{
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
        
        if let slotStartTime1 = dict["slotStartTime"] as? Int{
            slotStartTime = slotStartTime1
        }
        
        if let slotEndTime1 = dict["slotEndTime"] as? Int{
            slotEndTime = slotEndTime1
        }
        
        if let date_of_issue_utc1 = dict["date_of_issue_utc"] as? String{
            date_of_issue_utc = date_of_issue_utc1
        }
        
        if let remarks1 = dict["remarks"] as? String{
            remarks = remarks1
        }
        
        if let reason1 = dict["reason"] as? String{
            reason = reason1
        }
        
        if let booking_status1 = dict["booking_status"] as? Int{
            switch booking_status1{
            case BookingStatus.PENDING.rawValue:
                booking_status = BookingStatus.PENDING
            
            case BookingStatus.APPROVED.rawValue:
                booking_status = BookingStatus.APPROVED
                
            case BookingStatus.REJECTED.rawValue:
                booking_status = BookingStatus.REJECTED
                
            case BookingStatus.COMPLETED.rawValue:
                booking_status = BookingStatus.COMPLETED
                
            case BookingStatus.CANCELED.rawValue:
                booking_status = BookingStatus.CANCELED
                
            case BookingStatus.CANCELEDBYSYSTEM.rawValue:
                booking_status = BookingStatus.CANCELEDBYSYSTEM
                
            case BookingStatus.CALL_ONCE_SUCCESSFULL.rawValue:
                booking_status = BookingStatus.CALL_ONCE_SUCCESSFULL
                
            case BookingStatus.CALL_INITIATED.rawValue:
                booking_status = BookingStatus.CALL_INITIATED
                
            case BookingStatus.DOCTIR_CALL_PATIENT_GOT_ALERTED.rawValue:
                booking_status = BookingStatus.DOCTIR_CALL_PATIENT_GOT_ALERTED
                
            case BookingStatus.PATIENT_MISSED_THE_CALL.rawValue:
                booking_status = BookingStatus.PATIENT_MISSED_THE_CALL
                
            case BookingStatus.PATIENT_PICKS_THE_CALL.rawValue:
                booking_status = BookingStatus.PATIENT_PICKS_THE_CALL
                
            case BookingStatus.PATIENT_REJECTS_THE_CALL.rawValue:
                booking_status = BookingStatus.PATIENT_REJECTS_THE_CALL
                
            case BookingStatus.DOCTOR_HUNGS_THE_CALL.rawValue:
                booking_status = BookingStatus.DOCTOR_HUNGS_THE_CALL
                
            case BookingStatus.PATIENT_HUNGS_THE_CALL.rawValue:
                booking_status = BookingStatus.PATIENT_HUNGS_THE_CALL
                
            case BookingStatus.SOCKET_DISCONNECTED_CANCELED_BY_SYSTEM.rawValue:
                booking_status = BookingStatus.SOCKET_DISCONNECTED_CANCELED_BY_SYSTEM
                
            case BookingStatus.DOCTOR_NOT_REPLY.rawValue:
                booking_status = BookingStatus.DOCTOR_NOT_REPLY
                
            case BookingStatus.RESCHEDULE_BY_DOCTOR.rawValue:
                booking_status = BookingStatus.RESCHEDULE_BY_DOCTOR
                
            case BookingStatus.RESCHEDULE_BY_PATIENT.rawValue:
                booking_status = BookingStatus.RESCHEDULE_BY_PATIENT
                
            default:
                break
            }
        }
    }
}
