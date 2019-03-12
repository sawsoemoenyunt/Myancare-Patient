//
//  NotificationModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class NotificationModel
{
    var notificationID : String?
    var notification_type : String?
    var date : String?
    var dateString : String?
    var conversation_id : String?
    
    var isRead : Bool?
    
    var user : [String : Any]?
    var from_user : [String : Any]?
    var notification : [String : Any]?
    
    init()
    {
        notificationID = ""
        notification_type = ""
        date = ""
        dateString = ""
        conversation_id = ""
        
        isRead = false
        
        user = [:]
        from_user = [:]
        notification = [:]
    }
    
    deinit
    {
        print("Notification Model deinit")
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        if let id = dictionary["id"] as? String
        {
            notificationID = id
        }
        
        if let notification_type1 = dictionary["notification_type"] as? String
        {
            notification_type = notification_type1
        }
        
//        if let date1 = dictionary["created"] as? Int
//        {
//            date = String(date1)
//            
//            if (date?.count)! > 10 {
//                
//                let index2 = (date?.index((date?.startIndex)!, offsetBy: 10))
//                let indexStart = index2!
//                
//                let indexEnd = (date?.endIndex)!
//                
//                date?.removeSubrange(indexStart ..< indexEnd)
//            }
//            
//            let dateFormatter = DateFormatter()
//            
//            let date1 = Date(timeIntervalSince1970: Double(date!)!)
//            
//            dateFormatter.locale = NSLocale.current
//            
//            dateFormatter.timeZone = NSTimeZone.system
//            
////            let timeString = UtilityClass.timeAgoSinceDate(date1, currentDate: Date(), numericDates: false)
//            
////            dateString = timeString
//        }
        
        if let user1 = dictionary["user"] as? [String : Any]
        {
            user = user1
        }
        
        if let from_user1 = dictionary["from_user"] as? [String : Any]
        {
            from_user = from_user1
        }
        
        if let notification1 = dictionary["notification"] as? [String : Any]
        {
            notification = notification1
        }
        
        if let data = dictionary["data"] as? [String : Any]
        {
            conversation_id = data["conversation_id"] as? String
        }
    }
}
