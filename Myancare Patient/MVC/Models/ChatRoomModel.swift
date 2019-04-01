//
//  ChatRoomModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/30/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ChatRoomModel {
    
    var id : String?
    var doctor_id : String?
    var doctor_name : String?
    var doctor_imageUrl : String?
    var last_message : String?
    var last_messageStatus : Int?
    var last_messageType : Int?
    var createdAt : String?
    var timeAgo : String?
    
    init() {
        id = ""
        doctor_id = ""
        doctor_name = ""
        doctor_imageUrl = ""
        last_message = ""
        last_messageStatus = 1
        last_messageType = 1
        createdAt = ""
        timeAgo = ""
    }
    
    func updateModelUsingDict(_ dict:[String:Any]){
    
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let doctor = dict["doctor"] as? NSDictionary{
            if let docName = doctor.object(forKey: "name") as? String{
                doctor_name = docName
            }
            
            if let docID = doctor.object(forKey: "id") as? String{
                doctor_id = docID
            }
            
            if let docImage = doctor.object(forKey: "image_url") as? String{
                doctor_imageUrl = docImage
            }
        }
        
        if let message = dict["last_message"] as? NSDictionary{
            if let imageType = message.object(forKey: "image_type") as? Int{
                last_messageType = imageType
            }
            
            if let imageStatus = message.object(forKey: "status") as? Int{
                last_messageStatus = imageStatus
            }
            
            if let msg = message.object(forKey: "message") as? String{
                last_message = msg
            }
            
            if let date = message.object(forKey: "createdAt") as? String{
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                if let createdDate = formatter.date(from: date){
                    timeAgo = UtilityClass.timeAgoSinceDate(createdDate, currentDate: Date(), numericDates: true)
                }
                createdAt = date
            }
        }
    }
}
