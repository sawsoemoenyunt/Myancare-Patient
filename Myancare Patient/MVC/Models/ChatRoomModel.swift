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
    
    init() {
        id = ""
        doctor_id = ""
        doctor_name = ""
        doctor_imageUrl = ""
        last_message = ""
        last_messageStatus = 1
        last_messageType = 1
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
        }
    }
}
