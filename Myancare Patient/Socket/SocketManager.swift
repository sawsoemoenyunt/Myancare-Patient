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

class SocketManagerHandler: NSObject {
    
    //MARK:- SocketClient (Private)
    private var socket : SocketIOClient?
    private var socketMngr : SocketManager?
    static let shared = SocketManagerHandler()
    
    //MARK:- Instance Creation (Private)
    private static var instance : SocketManagerHandler =
    {
        let newInstance = SocketManagerHandler.init()
        return newInstance
    }()
    
    //MARK:- Shared Instance(Global)
    class func sharedInstance() -> SocketManagerHandler {
        return instance
    }
    
    //MARK:- Connect Socket Method
    func connectSocket(callback:@escaping (_ data:[Any], _ ack:SocketAckEmitter) -> ())
    {
        socket?.on(clientEvent: .connect, callback:
            { (dataArray, ack) in
                
                print("Connect listner : ", dataArray)
                
                callback (dataArray, ack)
        })
    
        socket?.connect()
        
        self.getAllChatRoomsListener()
        self.getChatRecordsListener()
        self.getChatMessageListener()
    }
    
    override init() {
        super.init()
        
//        let url = "http://159.65.10.176:5500"
        let url = "http://192.168.0.253:5500"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print("Socket server url : \(urlString!)")
        if let jwTToken = UserDefaults.standard.getToken(){
            jwtTkn = "Bearer \(jwTToken)"
        }
        
        socketMngr = SocketManager(socketURL: URL(string: "\(urlString!)")!, config: [.log(true),.compress])
        socketMngr?.config = SocketIOClientConfiguration(
            arrayLiteral: .compress, .connectParams(["token": "\(jwtTkn)"])
        )
        socket = socketMngr?.defaultSocket
        
        setupErrorListner()
        setupDisconnectListner()
    }
    
    
    //MARK:- Disconnect Socket Method
    func disconnectSocket()
    {
        socket?.disconnect()
        socketMngr?.disconnect()
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
    
    //MARK:- Socket Connection Status
    func isSocketConnected() -> Bool {
        return socket!.status == SocketIOStatus.connected
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
