//
//  NotificationModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

enum NotiTypeEnum:String{
    case NEW_APPOINTMENT = "NEW_APPOINTMENT"
    case APPOINTMENT_CANCEL = "APPOINTMENT_CANCEL"
    case APPOINTMENT_RESHEDULE = "APPOINTMENT_RESHEDULE"
    case APPOINTMENT_ACCEPTED = "APPOINTMENT_ACCEPTED"
    case APPOINTMENT_REJECTED = "APPOINTMENT_REJECTED"
    case NEXT_APPOINTMENT = "NEXT_APPOINTMENT"
    case APPOINTMENT_ACCEPTED_BY_DOC = "APPOINTMENT_ACCEPTED_BY_DOC"
    case APPOINTMENT_REJECTED_BY_DOC = "APPOINTMENT_REJECTED_BY_DOC"
    case NEXT_APPOINTMENT_FIVE = "NEXT_APPOINTMENT_FIVE"
    case CHAT_EXPIRY = "CHAT_EXPIRY"
    case CHAT_APPOINTMENT_REJECTED = "CHAT_APPOINTMENT_REJECTED"
    case NEW_CHAT_APPOINTMENT = "NEW_CHAT_APPOINTMENT"
    case CHAT_APPOINTMENT_ACCEPTED = "CHAT_APPOINTMENT_ACCEPTED"
    case CHAT_APPOINTMENT_ACCEPTED_BY_DOC = "CHAT_APPOINTMENT_ACCEPTED_BY_DOC"
    case DOCTOR_MISSED_APPOINTMENT_PATIENT = "DOCTOR_MISSED_APPOINTMENT_PATIENT"
    case DOCTOR_MISSED_APPOINTMENT = "DOCTOR_MISSED_APPOINTMENT"
    case CHAT_EXPIRY_FIVE = "CHAT_EXPIRY_FIVE"
    case MEDICATION_REMINDER = "MEDICATION_REMINDER"
    case CHAT = "CHAT"
    case VOIP = "VOIP"
    case DEFAULT = "DEFAULT"
}

class NotificationModel
{
    var isRead : Bool?
    var send_by_admin : Bool?
    var is_doctor : Bool?
    var id : String?
    var user : String?
    var notification_type : NotiTypeEnum?
    var from_user : String?
    var message_title : String?
    var message_body : String?
    var createdAt : String?
    var updatedAt : String?
    
    init() {
        isRead = false
        send_by_admin = false
        is_doctor = false
        id = ""
        user = ""
        notification_type = NotiTypeEnum.DEFAULT
        from_user = ""
        message_title = ""
        message_body = ""
        createdAt = ""
        updatedAt = ""
    }
    
    func updateModelUsingDic(_ dict:[String:Any]){
        if let isRead1 = dict["isRead"] as? Bool{
            isRead = isRead1
        }
        
        if let send_by_admin1 = dict["send_by_admin"] as? Bool{
            send_by_admin = send_by_admin1
        }
        
        if let is_doctor1 = dict["is_doctor"] as? Bool{
            is_doctor = is_doctor1
        }
        
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let user1 = dict["user"] as? String{
            user = user1
        }
        
        if let notification_type1 = dict["notification_type"] as? String{
            switch notification_type1{
            case NotiTypeEnum.APPOINTMENT_ACCEPTED.rawValue:
                notification_type = NotiTypeEnum.APPOINTMENT_ACCEPTED
                break
            case NotiTypeEnum.APPOINTMENT_ACCEPTED_BY_DOC.rawValue:
                notification_type = NotiTypeEnum.APPOINTMENT_ACCEPTED_BY_DOC
                break
            case NotiTypeEnum.APPOINTMENT_CANCEL.rawValue:
                notification_type = NotiTypeEnum.APPOINTMENT_CANCEL
                break
            case NotiTypeEnum.APPOINTMENT_REJECTED.rawValue:
                notification_type = NotiTypeEnum.APPOINTMENT_REJECTED
                break
            case NotiTypeEnum.APPOINTMENT_REJECTED_BY_DOC.rawValue:
                notification_type = NotiTypeEnum.APPOINTMENT_REJECTED_BY_DOC
                break
            case NotiTypeEnum.APPOINTMENT_RESHEDULE.rawValue:
                notification_type = NotiTypeEnum.APPOINTMENT_RESHEDULE
                break
            case NotiTypeEnum.CHAT.rawValue:
                notification_type = NotiTypeEnum.CHAT
                break
            case NotiTypeEnum.CHAT_APPOINTMENT_ACCEPTED.rawValue:
                notification_type = NotiTypeEnum.CHAT_APPOINTMENT_ACCEPTED
                break
            case NotiTypeEnum.CHAT_APPOINTMENT_ACCEPTED_BY_DOC.rawValue:
                notification_type = NotiTypeEnum.CHAT_APPOINTMENT_ACCEPTED_BY_DOC
                break
            case NotiTypeEnum.CHAT_APPOINTMENT_REJECTED.rawValue:
                notification_type = NotiTypeEnum.CHAT_APPOINTMENT_REJECTED
                break
            case NotiTypeEnum.CHAT_EXPIRY.rawValue:
                notification_type = NotiTypeEnum.CHAT_EXPIRY
                break
            case NotiTypeEnum.CHAT_EXPIRY_FIVE.rawValue:
                notification_type = NotiTypeEnum.CHAT_EXPIRY_FIVE
                break
            case NotiTypeEnum.DOCTOR_MISSED_APPOINTMENT.rawValue:
                notification_type = NotiTypeEnum.DOCTOR_MISSED_APPOINTMENT
                break
            case NotiTypeEnum.DOCTOR_MISSED_APPOINTMENT_PATIENT.rawValue:
                notification_type = NotiTypeEnum.DOCTOR_MISSED_APPOINTMENT_PATIENT
                break
            case NotiTypeEnum.MEDICATION_REMINDER.rawValue:
                notification_type = NotiTypeEnum.MEDICATION_REMINDER
                break
            case NotiTypeEnum.NEW_APPOINTMENT.rawValue:
                notification_type = NotiTypeEnum.NEW_APPOINTMENT
                break
            case NotiTypeEnum.NEW_CHAT_APPOINTMENT.rawValue:
                notification_type = NotiTypeEnum.NEW_CHAT_APPOINTMENT
                break
            case NotiTypeEnum.NEXT_APPOINTMENT.rawValue:
                notification_type = NotiTypeEnum.NEXT_APPOINTMENT
                break
            case NotiTypeEnum.NEXT_APPOINTMENT_FIVE.rawValue:
                notification_type = NotiTypeEnum.NEXT_APPOINTMENT_FIVE
                break
            case NotiTypeEnum.VOIP.rawValue:
                notification_type = NotiTypeEnum.VOIP
                break
            default:
                notification_type = NotiTypeEnum.DEFAULT
                break
            }
        }
        
        if let from_user1 = dict["from_user"] as? String{
            from_user = from_user1
        }
        
        if let createdAt1 = dict["createdAt"] as? String{
            createdAt = createdAt1
        }
        
        if let updatedAt1 = dict["updatedAt"] as? String{
            updatedAt = updatedAt1
        }
        
        if let messageDict = dict["message"] as? NSDictionary{
            
            if let message = messageDict.object(forKey: "title") as? String{
                message_title = message
            }
            
            if let title = messageDict.object(forKey: "body") as? String{
                message_body = title
            }
        }
    }
}
