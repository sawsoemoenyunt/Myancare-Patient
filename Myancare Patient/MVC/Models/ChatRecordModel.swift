//
//  ChatRecordModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/1/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ChatRecordModel{
    
    var id : String?
    var createdAt : String?
    var updatedAt : String?
    var image_type : Int? //0 = message, 1 = image
    var message : String?
    var status : Int? //1 = seen
    var userDict : NSDictionary? //id, image_url, role, username
    var userID : String?
    var userImage : String?
    var userRole : String?
    var userName : String?
    
    init() {
        id = ""
        createdAt = ""
        updatedAt = ""
        image_type = 0
        message = ""
        status = 0
        userDict = NSDictionary()
        userID = ""
        userImage = ""
        userRole = ""
        userName = ""
    }
    
    func updateModelUsingDict(_ dict:[String:Any]){
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let createdAt1 = dict["createdAt"] as? String{
            createdAt = createdAt1
        }
        
        if let updatedAt1 = dict["updatedAt"] as? String{
            updatedAt = updatedAt1
        }
        
        if let image_type1 = dict["image_type"] as? Int{
            image_type = image_type1
        }
        
        if let message1 = dict["message"] as? String{
            message = message1
        }
        
        if let status1 = dict["status"] as? Int{
            status = status1
        }
        
        if let user = dict["user"] as? NSDictionary{
            
            userDict = user
            
            if let userID1 = user.object(forKey: "id") as? String{
                userID = userID1
            }
            
            if let userImage1 = user.object(forKey: "image_url") as? String{
                userImage = userImage1
            }
            
            if let userRole1 = user.object(forKey: "role") as? String{
                userRole = userRole1
            }
            
            if let userName1 = user.object(forKey: "username") as? String{
                userName = userName1
            }
        }
    }
}
