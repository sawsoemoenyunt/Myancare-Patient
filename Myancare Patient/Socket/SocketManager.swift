//
//  SocketManager.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/25/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation
import SocketIO
import PKHUD

//MARK:- Socket Calling Keyword
enum SocketManageCallEventKeyword:String
{
    
    case callEventEnded = "call_ended"
    
    case callEventInitiated = "call_initiated"
    case callEventPatientCall = "patient_calls"
    case callEventPatientHangs = "patient_hungs_the_call"
    
    case callEventDoctorMiss = "doctor_missed_the_call"
    case callEventDoctorPicked = "doctor_picks_the_call"
    case callEventDoctorReject = "doctor_rejects_the_call"
    case callEventDoctorHangs = "doctor_hungs_the_call"
}

class SocketManagerHandler: NSObject {
    
    //MARK:- SocketClient (Private)
    private var socket : SocketIOClient?
    var socketMngr : SocketManager?
    static let shared = SocketManagerHandler()
    
    //MARK:- Instance Creation (Private)
    private static var instance : SocketManagerHandler =
    {
        let newInstance = SocketManagerHandler.init()
        return newInstance
    }()
    
    private override init() {
        super.init()
    }
    
    //MARK:- Shared Instance(Global)
    class func sharedInstance() -> SocketManagerHandler {
        return instance
    }
    
    //MARK:- Connect Socket Method
    func connectSocket(callback:@escaping (_ data:[Any], _ ack:SocketAckEmitter) -> ())
    {
        let url = "http://52.76.5.165:9999/"
        
        // Initializing the socket client for socket host
        socketMngr = SocketManager(socketURL: URL(string: url)!, config: [.log(true), .reconnects(true), .connectParams(["token": "\(jwtTkn)"]), .reconnectAttempts(-1), .forceNew(true), .reconnectWait(1), .compress])
        
        socket = socketMngr?.defaultSocket
        setupErrorListner()
        setupDisconnectListner()
        
        socket?.on(clientEvent: .connect, callback:
            { (dataArray, ack) in
                
                print("Connect listner : ", dataArray)
                
                callback (dataArray, ack)
                
                self.removeAllChatRoomsListener()
                self.removeChatRecordsListener()
                self.removeChatMessageListener()
                self.removeappointmentTimeupListener()
                
                self.getAllChatRoomsListener()
                self.getChatRecordsListener()
                self.getChatMessageListener()
                self.appointmentTimeupListener()
        })
        
        socket?.connect()
    }
    
    func removeAllChatRoomsListener(){
        if isSocketConnected(){
            socket?.off("rooms")
        }
    }
    
    func removeChatRecordsListener(){
        if isSocketConnected(){
            socket?.off("messages")
        }
    }
    
    func removeChatMessageListener(){
        if isSocketConnected(){
            socket?.off("message")
        }
    }
    
    func removeappointmentTimeupListener(){
        if isSocketConnected(){
            socket?.off("appointmentTimeup")
        }
    }
    
    //MARK:- Disconnect Socket Method
    func disconnectSocket()
    {
        
        print("my socket dc")
        self.removeAllChatRoomsListener()
        self.removeChatRecordsListener()
        self.removeChatMessageListener()
        self.removeappointmentTimeupListener()
        
        socket?.disconnect()
        socketMngr?.disconnect()
    }
    
    //MARK:- Socket Connection Status
    func isSocketConnected() -> Bool {
        return socket!.status == SocketIOStatus.connected
    }
    
    //MARK:- Error Listener
    func setupErrorListner()
    {
        socket?.on(clientEvent: .error, callback:
            { (dataArray, ack) in
                print("Error listner : ", dataArray)
        })
    }
    
    //MARK:- Disconnect Listener
    func setupDisconnectListner()
    {
        socket?.on(clientEvent: .disconnect, callback:
            { (dataArray, ack) in
                print("Disconnect listner : ", dataArray)
        })
    }
    
    func appointmentTimeupListener(){
        socket?.on("appointmentTimeup", callback: { (data, socketAck) in
            NotificationCenter.default.post(name: Notification.Name.didReceiveAppointmentTimeUp, object: nil, userInfo: nil)
        })
    }
    
    //send call log
    func emitCallLog(appointmentID:String, eventType:String, callDuration:Int){
        socket?.emit("calllog", [appointmentID, eventType, callDuration])
    }
    
    //Send message
    func emitChatMessage(roomID:String, messageString:String, imageType:Int){
        socket?.emit("message", [roomID, messageString, imageType])
    }
    
    func getChatMessageListener(){
        socket?.on("message", callback: { (dataArray, socketAck) in
            if let dataFirstIndex = dataArray[0] as? String{
                if let data = dataFirstIndex.data(using: .utf8){
                    do{
                        if let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{

                            let message = ChatRecordModel()
                            message.updateModelUsingDict(jsonData)
                            
                            let userInfo = ["data":message]
                            NotificationCenter.default.post(name: Notification.Name.didReceiveDataForNewChatMessage, object: nil, userInfo: userInfo)
                        }
                    } catch let error{
                        print("\(error)")
                    }
                }
            }
        })
    }
    
    ///Chat records
    func emitChatRecords(roomID:String, skip:Int, limit:Int){
        socket?.emit("join", [roomID, skip, limit])
    }
    
    func getChatRecordsListener(){
        socket?.on("messages", callback: { (dataArray, socketAck) in
            
            if let dataFirstIndex = dataArray[0] as? String{
                if let data = dataFirstIndex.data(using: .utf8){
                    do{
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]{
                            var chatRecords = [ChatRecordModel]()
                            
                            for data in jsonArray{
                                if let dataDict = data as? [String:Any]{
                                    let record = ChatRecordModel()
                                    record.updateModelUsingDict(dataDict)
                                    chatRecords.append(record)
                                }
                            }
                            let userInfo = ["data":chatRecords]
                            NotificationCenter.default.post(name: Notification.Name.didReceiveDataForChatRecord, object: nil, userInfo: userInfo)
                        }
                    } catch let error{
                        print("\(error)")
                    }
                }
            }
        })
    }
    
    ///Chat rooms
    func emitChatRooms(skip:Int, limit:Int){
        socket?.emit("rooms", [skip,limit]) //skip,limit
    }
    
    func getAllChatRoomsListener(){
        
        socket?.on("rooms", callback: { (dataArray, socketAck) in
           
            if let dataFirstIndex = dataArray[0] as? String{
                if let data = dataFirstIndex.data(using: .utf8){
                    do{
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]{
                            var chatRoomList = [ChatRoomModel]()
                            chatRoomList.removeAll()
                            
                            for data in jsonArray{
                                if let dataDict = data as? [String:Any]{
                                    let room = ChatRoomModel()
                                    room.updateModelUsingDict(dataDict)
                                    chatRoomList.append(room)
                                }
                            }
                            let userInfo = ["data":chatRoomList]
                            NotificationCenter.default.post(name: .didReceiveDataForChatRoomList, object: nil, userInfo: userInfo)
                        }
                    } catch let error{
                        print("\(error)")
                    }
                }
            }
        })
    }
}
