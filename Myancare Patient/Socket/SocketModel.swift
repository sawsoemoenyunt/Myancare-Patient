//
//  SocketModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/25/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ModelChatMessage{
    
    // Message
    var message = ""
    var messageID = ""
    var messageTime = "Today 02:00 AM"
    
    // Sender
    var senderID = ""
    var senderName = ""
    var senderPicture = ""
    
    var isMsgSendByMe = false
    var isMedia = false
    
    // Receiver
    var receiverID = ""
    var receiverName = ""
    var receiverPicture = ""
    var roomID = ""
    var thumbString = ""
    var fullImageString = ""
    
    deinit
    {
        print("ModelChatMessage Deinit")
    }
    
    func updateModel(usingDictionary dictionary : [String:Any])
    {
        if let msgID = dictionary["id"] as? String
        {
            self.messageID = msgID
        }
        
        if let room_id = dictionary["conversation"] as? String
        {
            self.roomID = room_id
        }
        
        if let msgSender = dictionary["message_by"] as? [String:Any]
        {
            let msgSenderID = msgSender["id"] as! String
            
            if msgSenderID == UserDefaults.standard.getUserData().object(forKey: "_id") as? String
            {
                isMsgSendByMe = true
            }
        }
        
        if let msgSender = dictionary["message_by"] as? [String:Any]
        {
            senderName = msgSender["name"] as! String
            senderID = msgSender["id"] as! String
            senderPicture = msgSender["avatar_url"] as! String
        }
        
        if let msgSender = dictionary["message_to"] as? [String:Any]
        {
            receiverName = msgSender["name"] as! String
            receiverID = msgSender["id"] as! String
            receiverPicture = msgSender["avatar_url"] as! String
        }
        
        if let message = dictionary["body"] as? String
        {
            self.message = message
        }
        
        if let filePath = dictionary["file_path"] as? String
        {
            if filePath.isEmpty == false
            {
                self.isMedia = true
                self.thumbString = dictionary["image_url_w200"] as! String
                self.fullImageString = dictionary["image_url_org"] as! String
            }
        }
        
        if let created = dictionary["createdTime"] as? Double
        {
            self.messageTime = String(created)
            
            if (self.messageTime.count) > 10
            {
                let index2 = (self.messageTime.index((self.messageTime.startIndex), offsetBy: 10))
                let indexStart = index2
                
                let indexEnd = (self.messageTime.endIndex)
                
                self.messageTime.removeSubrange(indexStart ..< indexEnd)
            }
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.timeZone = NSTimeZone.system
            
            let date1 = Date(timeIntervalSince1970: Double(self.messageTime)!)
            
            dateFormatter.locale = NSLocale.current
            
//            let timeString = UtilityClass.timeAgoSinceDateChat(date1, currentDate: Date(), numericDates: false)
            
//            self.messageTime = timeString
        }
        
        if let receiver = dictionary["receiver"] as? String
        {
            self.receiverID = receiver
        }
    }
}

//MARK:- SocketParametersKeyword
// Socket functions parameters
enum SocketParametersKeyword : String
{
    case ReceieverID = "receiver"
    case Message = "message"
    
    case isMedia = "isMedia"
    
    // Chat History
    case RoomID = "room_id"
    case UserID = "user_id"
    
    // Like-Unlike message
    case MessageID = "message_id"
    case action = "action"
}


//MARK:- SocketModelSendMessage
// Send message model class
class SocketModelSendMessage
{
    var message = ""
    var receiverID = ""
    
    init(_ receiverID : String, message : String)
    {
        self.receiverID = receiverID
        self.message = message
    }
    
    func getDictionary() -> [String:String]
    {
        return [
            SocketParametersKeyword.ReceieverID.rawValue : receiverID,
            SocketParametersKeyword.Message.rawValue : message
        ]
    }
}

//MARK:- SocketModelSendGroupMessage
// Send group message model class
class SocketModelSendGroupMessage
{
    var message = ""
    var roomID = ""
    var isMedia = false
    
    init(_ roomID : String, message : String, isMedia: Bool)
    {
        self.roomID = roomID
        self.message = message
        self.isMedia = isMedia
    }
    
    func getDictionary() -> [String:String]
    {
        return [
            SocketParametersKeyword.RoomID.rawValue : roomID,
            SocketParametersKeyword.Message.rawValue : message,
            SocketParametersKeyword.isMedia.rawValue : isMedia ? "1" : "0"
        ]
    }
}


//MARK:- SocketModelGetHistory
// Get chat history with the user or group
class SocketModelGetHistory
{
    var userID : String?
    var roomID : String?
    
    init(_ userID : String?, roomID : String?)
    {
        self.userID = userID
        self.roomID = roomID
    }
    
    func getDictionary() -> [String:String]
    {
        if roomID == nil
        {
            return [
                SocketParametersKeyword.UserID.rawValue : self.userID!
            ]
        }
        
        return [
            SocketParametersKeyword.RoomID.rawValue : self.roomID!,
            SocketParametersKeyword.UserID.rawValue : self.userID ?? ""
        ]
    }
}

//MARK:- SocketModelLikeMessage
// Like message
class SocketModelLikeMessage
{
    var messageID : String?
    var roomID : String?
    var like = false
    
    
    init(_ messageID : String?, roomID : String?, like : Bool)
    {
        self.messageID = messageID
        self.roomID = roomID
        self.like = like
    }
    
    func getDictionary() -> [String:String]
    {
        return [
            SocketParametersKeyword.RoomID.rawValue : self.roomID!,
            SocketParametersKeyword.MessageID.rawValue : self.messageID!,
            SocketParametersKeyword.action.rawValue : self.like ? "1" : "0"
        ]
    }
}
