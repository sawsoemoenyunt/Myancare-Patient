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
    }
    
    override init() {
        super.init()
        let url = "http://159.65.10.176?token=\(jwtTkn)"
        let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print("Socket server url : \(urlString!)")
        
        socketMngr = SocketManager(socketURL: URL(string: "\(urlString!)")!, config: [.log(true),.compress])
        socket = socketMngr?.defaultSocket
        
        socket?.connect()
        
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
    
    func getAllChatRooms(result: @escaping ([ChatRoomModel]) -> ()){
        socket?.emit("rooms", [0,10])
        
        socket?.on("rooms", callback: { (dataArray, socketAck) in
            print("Return data from socket : \(dataArray)")
            print("Return socket ack : \(socketAck)")
            
            var chatRoomList = [ChatRoomModel]()
            
            for data in dataArray{
                if let dataDict = data as? [String:Any]{
                    let room = ChatRoomModel()
                    room.updateModelUsingDict(dataDict)
                    chatRoomList.append(room)
                }
            }
            result(chatRoomList)
        })
    }
}
