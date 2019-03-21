//
//  SocketIOManager.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/21/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

//import Foundation
//import SocketIO
//
//class SocketIOManager: NSObject {
//    static let sharedInstance = SocketIOManager()
//    
//    let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .compress])
//    var socket:SocketIOClient?
//    
//    
//    override init() {
//        super.init()
//        socket = manager.defaultSocket
//    }
//    
//    
//    func establishConnection() {
//        socket!.connect()
//    }
//    
//    
//    func closeConnection() {
//        socket!.disconnect()
//    }
//    
//    
//    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
//        socket!.emit("connectUser", nickname)
//        
//        socket!.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(dataArray[0] as? [[String: AnyObject]])
//        }
//        
//        listenForOtherMessages()
//    }
//    
//    
//    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
//        socket!.emit("exitUser", nickname)
//        completionHandler()
//    }
//    
//    
//    func sendMessage(message: String, withNickname nickname: String) {
//        socket!.emit("chatMessage", nickname, message)
//    }
//    
//    
//    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
//        socket!.on("newChatMessage") { (dataArray, socketAck) -> Void in
//            var messageDictionary = [String: Any]()
//            messageDictionary["nickname"] = dataArray[0] as! String
//            messageDictionary["message"] = dataArray[1] as! String
//            messageDictionary["date"] = dataArray[2] as! String
//            
//            completionHandler(messageDictionary as [String : AnyObject])
//        }
//    }
//    
//    
//    private func listenForOtherMessages() {
//        socket!.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
//        }
//        
//        socket!.on("userExitUpdate") { (dataArray, socketAck) -> Void in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
//        }
//        
//        socket!.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
//        }
//    }
//    
//    
//    func sendStartTypingMessage(nickname: String) {
//        socket!.emit("startType", nickname)
//    }
//    
//    
//    func sendStopTypingMessage(nickname: String) {
//        socket!.emit("stopType", nickname)
//    }
//}
