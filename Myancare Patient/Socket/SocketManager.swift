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
    // doctor_calls|call_initiated|patient_missed_the_call|patient_picks_the_call|patient_rejects_the_call|doctor_hungs_the_call
    case callEventdoctorCall = "doctor_calls"
    case callEventInitiated = "call_initiated"
    case callEventPatientMiss = "patient_missed_the_call"
    case callEventPatientPicked = "patient_picks_the_call"
    case callEventPatientReject = "patient_rejects_the_call"
    case callEventDoctorHangs = "doctor_hungs_the_call"
}

//MARK:- Socket Listener Keywords
enum SocketListenerKeywords:String {
    
    case get = "get"
    case post = "post"
    case delete = "delete"
    
    case postMessageURL = "/message"
    case postCreateConversation = "/conversation"
    case postEnableChatButton = "/appointments/enable_appointment_btn"
    case postmanageCall = "/appointments/manage_calls"
    
    //Listner
    case newMessage = "NEW_MESSAGE"
    case notificationCount = "NOTIFICATION_COUNT"
    
    case enableCallButton = "ENABLE_CALL_BUTTON"
    case endAppointmentTime = "DISABLE_CALL_BUTTON"
    
    case updateDoctorStatus = "UPDATE_DOCTOR_STATUS"
    
    case nextAppointmentFive = "NEXT_CALL_APPOINTMENT_FIVE"
    case doctorDeclineCall = "DOCTOR_DECLINE_CALL"
    case doctorAcceptedCall = "DOCTOR_ACCEPTED_CALL"
}

enum ErrorCodes : Int {
    case SocketNotConnected = 001
}

//MARK:- Notification Keys
let NOTIFICATION_SOCKET_CONNECTED : String = "socketConnected"

////MARK:-
////MARK:- Socket Host
//MARK: -> Dev
var SocketHost = "http://202.157.76.19:15004"

class SocketManagerHandler: NSObject {
    
    //MARK: Listener block
    typealias ListenerHandler = (_ data:[Any], _ ack:SocketAckEmitter) -> ()
    
    typealias MessageHandler = (_ messageDict:[String:Any] , _ statusCode:Int) -> ()
    
    typealias MessageListHandler = (_ messageDict:[[String:Any]] , _ statusCode:Int) -> ()
    
    typealias ChatHistoryHandler = (_ chatHistoryArray:[[String:Any]] , _ statusCode:Int) -> ()
    
    typealias ChatHistoryHasSlotHandler = (_ chatHistoryArray:[[String:Any]] , _ statusCode:Int , _ hasSlot:String, _ slotStartTime : String, _ slotEndTime : String) -> ()
    
    typealias SingleChatHistoryHandler = (_ chatHistoryArray:[[String:Any]], _ isBlocked: Bool , _ statusCode:Int) -> ()
    
    typealias GroupChatHistoryHandler = (_ chatHistoryArray:[[String:Any]], _ position: String , _ statusCode:Int) -> ()
    
    //MARK:- SocketClient (Private)
    private var socket : SocketIOClient?
    private var socketMngr : SocketManager?
    
    //MARK:- Instance Creation (Private)
    private static var instance : SocketManagerHandler =
    {
        let newInstance = SocketManagerHandler.init()
        
        return newInstance
    }()
    
    //MARK:- init (Private)
    private override init() {
        
        super.init()
        
        // Initializing the socket client for socket host
        socketMngr = SocketManager(socketURL: URL(string: baseURLString)!, config: [.log(true), .reconnects(true), .reconnectAttempts(-1), .reconnectWait(1), .compress, .forceNew(true), .connectParams(["__sails_io_sdk_version":"0.11.0"]), .forcePolling(true)])
        
        socket = socketMngr!.defaultSocket
        
        setupErrorListner()
        setupDisconnectListner()
    }
    
    //MARK:- SSID Var (updates the configuration of socket, Only set before connection)
    var userSID : String!
    {
        didSet
        {
            _ = SocketIOClientConfiguration (arrayLiteral: .log(true), .reconnects(true), .reconnectAttempts(-1), .reconnectWait(1), .compress, .connectParams(["ssid" : userSID]), .forceNew(true), .path("/socket.io/"))
            
            print("logged in sid is : ",userSID)
        }
    }
    
    //MARK:- Shared Instance(Global)
    class func sharedInstance() -> SocketManagerHandler {
        return instance
    }
    
    //MARK:- Connect Socket Method
    func connectSocket(callback:@escaping ListenerHandler)
    {
        socket?.on(clientEvent: .connect, callback:
            { (dataArray, ack) in
                
                print("Connect listner : ", dataArray)
                
                callback (dataArray, ack)
                
                if UserDefaults.standard.getToken() != nil
                {
                    self.subscribeRoom()
                }
        })
        
        socket?.connect()
    }
    
    //MARK:- Disconnect Socket Method
    func disconnectSocket()
    {
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
    
    //MARK: Calling Emit Methods
    //MARK:- Doctor Socket Manage Call Events (Emit)
    func manageCallSocketEvent(_ callDuration : String,eventType : String, appointmentID : String,messageHandler : MessageHandler?)
    {
        
        let data = ["call_duration":callDuration,
                    "appointment_id":appointmentID,
                    "event_type": eventType,
                    "authorization":UserDefaults.standard.getToken()]
        
        // Generating Dictionary from Model
        let params = ["url":SocketListenerKeywords.postmanageCall.rawValue,
                      "data":data] as [String : Any]
        
        // Emitting the 'newMessage' event and handling the response
        socket?.emitWithAck(SocketListenerKeywords.post.rawValue, with: [params]).timingOut(after: 0, callback:
            { (dataArray) in
                
                print(dataArray)
                
                // If handler is set as nil, then return (no need to move further)
                if messageHandler == nil
                {
                    return
                }
                
                // If handler is implemented
                // If returned response array has data in it, then retreiving the dictionary object
                if let responseDictionary = dataArray[0] as? [String:Any]
                {
                    // Calling the handler
                    messageHandler!(responseDictionary, 200)
                }
        })
    }
    
    //MARK:- Create Conversation (Emit)
    func createConversation(_ doctorID : String, messageHandler : MessageHandler?)
    {
        let data = [
            "doctor" : doctorID,
            "authorization" : UserDefaults.standard.getToken()
        ]
        
        // Generating Dictionary from Model
        let params = [
            "url" : SocketListenerKeywords.postCreateConversation.rawValue,
            "data" : data
            ] as [String : Any]
        
        // Emitting the 'newMessage' event and handling the response
        socket?.emitWithAck(SocketListenerKeywords.post.rawValue, with: [params]).timingOut(after: 0, callback:
            { (dataArray) in
                
                print(dataArray)
                
                // If handler is set as nil, then return (no need to move further)
                if messageHandler == nil
                {
                    return
                }
                
                // If handler is implemented
                // If returned response array has data in it, then retreiving the dictionary object
                if let responseDictionary = dataArray[0] as? [String:Any]
                {
                    // Fetching the status code
                    let statusCode = responseDictionary["statusCode"] as! Int
                    
                    // Fetching the data dictionary
                    let bodyDict = responseDictionary["body"] as! [String:Any]
                    
                    let actualData = bodyDict["data"] as! [String:Any]
                    
                    // Calling the handler
                    messageHandler!(actualData,statusCode)
                }
        })
    }
    
    // MARK:- Sent Message (Emit)
    func sendMessage(_ message : String, _ doctorID : String,filePath : String, conversationID : String, messageHandler : MessageHandler?)
    {
        let data = [
            "conversation" : conversationID,
            "message_to" : doctorID,
            "body" : message,
            "file_path" : filePath,
            "authorization" : UserDefaults.standard.getToken()
        ]
        
        // Generating Dictionary from Model
        let params = [
            "url" : SocketListenerKeywords.postMessageURL.rawValue,
            "data":data
            ] as [String : Any]
        
        // Emitting the 'newMessage' event and handling the response
        socket?.emitWithAck(SocketListenerKeywords.post.rawValue, with: [params]).timingOut(after: 0, callback:
            { (dataArray) in
                
                print(dataArray)
                
                // If handler is set as nil, then return (no need to move further)
                if messageHandler == nil
                {
                    return
                }
                
                // If handler is implemented
                // If returned response array has data in it, then retreiving the dictionary object
                if let responseDictionary = dataArray[0] as? [String:Any]
                {
                    // Fetching the status code
                    let statusCode = responseDictionary["statusCode"] as! Int
                    
                    // Fetching the data dictionary
                    let bodyDict = responseDictionary["body"] as! [String:Any]
                    
                    let actualData = bodyDict["data"] as! [String:Any]
                    
                    // Calling the handler
                    messageHandler!(actualData,statusCode)
                }
        })
    }
    
    //MARK:- Create Conversation (Emit)
    func getConversationList(messageHandler : MessageListHandler?)
    {
        let data = [
            "authorization" : UserDefaults.standard.getToken()
        ]
        
        // Generating Dictionary from Model
        let params = [
            "url" : SocketListenerKeywords.postCreateConversation.rawValue,
            "data" : data
            ] as [String : Any]
        
        // Emitting the 'newMessage' event and handling the response
        socket?.emitWithAck(SocketListenerKeywords.get.rawValue, with: [params]).timingOut(after: 5, callback:
            { (dataArray) in
                
                print(dataArray)
                
                // If handler is set as nil, then return (no need to move further)
                if messageHandler == nil
                {
                    return
                }
                
                // If handler is implemented
                // If returned response array has data in it, then retreiving the dictionary object
                if let responseDictionary = dataArray[0] as? [String:Any]
                {
                    // Fetching the status code
                    let statusCode = responseDictionary["statusCode"] as! Int
                    
                    if statusCode == 200
                    {
                        // Fetching the data dictionary
                        let bodyDict = responseDictionary["body"] as! [String:Any]
                        
                        let actualData = bodyDict["data"] as! [[String : Any]]
                        
                        // Calling the handler
                        messageHandler!(actualData, statusCode)
                    }
                    else
                    {
                        // Calling the handler
                        messageHandler!([], statusCode)
                    }
                }
                else
                {
                    // Calling the handler
                    messageHandler!([], 0)
                }
        })
    }
    
    //MARK:- Get Button Enable Status (Emit)
    func getButtonEnableStatus(_appointmentID : String, messageHandler : MessageHandler?)
    {
        let data = [
            "authorization" : UserDefaults.standard.getToken(),
            "appointment_id" : _appointmentID
        ]
        
        // Generating Dictionary from Model
        let params = [
            "url" : SocketListenerKeywords.postEnableChatButton.rawValue,
            "data" : data
            ] as [String : Any]
        
        // Emitting the 'newMessage' event and handling the response
        socket?.emitWithAck(SocketListenerKeywords.get.rawValue, with: [params]).timingOut(after: 0, callback:
            { (dataArray) in
                
                print(dataArray)
                
                // If handler is set as nil, then return (no need to move further)
                if messageHandler == nil
                {
                    return
                }
                
                // If handler is implemented
                // If returned response array has data in it, then retreiving the dictionary object
                if let responseDictionary = dataArray[0] as? [String:Any]
                {
                    // Fetching the status code
                    let statusCode = responseDictionary["statusCode"] as! Int
                    
                    // Fetching the data dictionary
                    let bodyDict = responseDictionary["body"] as! [String:Any]
                    
                    print(bodyDict)
                    let actualData = bodyDict["data"] as! [String : Any]
                    
                    // Calling the handler
                    messageHandler!(actualData,statusCode)
                }
        })
    }
    
    //MARK:- Get Chat History Data  (Emit)
    func getChatHistory(_ conversationID : String, doctorID :String, patientID : String, chatHistoryHandler : ChatHistoryHasSlotHandler?)
    {
        if !isSocketConnected() {
            HUD.hide()
            return
        }
        
        let data = [
            "authorization" : UserDefaults.standard.getToken(),
            "limit" : "100000",
            "doctor_id":doctorID,
            "patient_id":patientID,
            ]
        
        let strURL = String.init(format: "%@/%@", SocketListenerKeywords.postCreateConversation.rawValue,conversationID)
        
        // Generating Dictionary from Model
        
        let params = [
            "url":strURL,
            "data":data
            ] as [String : Any]
        
        // Emitting the 'newMessage' event and handling the response
        socket?.emitWithAck(SocketListenerKeywords.get.rawValue, with: [params]).timingOut(after: 0, callback:
            { (dataArray) in
                
                print(dataArray)
                
                // If handler is set as nil, then return (no need to move further)
                if chatHistoryHandler == nil
                {
                    return
                }
                
                // If handler is implemented
                // If returned response array has data in it, then retreiving the dictionary object
                if let responseDictionary = dataArray[0] as? [String:Any]
                {
                    // Fetching the status code
                    let statusCode = responseDictionary["statusCode"] as! Int
                    
                    // Fetching the data dictionary
                    let bodyDict = responseDictionary["body"] as! [String:Any]
                    
                    let extraDict = bodyDict["extra"] as! [String:Any]
                    
                    let value = extraDict["hasSlot"] as! String
                    
                    var slotStartTime = ""
                    var slotEndTime = ""
                    
                    if value == "1"
                    {
                        let slotEndTime1 = extraDict["slotEndTime"] as! Double
                        let slotStartTime1 = extraDict["slotStartTime"] as! Double
                        
                        slotStartTime = String(slotStartTime1)
                        
                        if (slotStartTime.count) > 10
                        {
                            let index2 = (slotStartTime.index((slotStartTime.startIndex), offsetBy: 10))
                            let indexStart = index2
                            
                            let indexEnd = (slotStartTime.endIndex)
                            
                            slotStartTime.removeSubrange(indexStart ..< indexEnd)
                        }
                        
                        slotEndTime = String(slotEndTime1)
                        
                        if (slotEndTime.count) > 10
                        {
                            let index2 = (slotEndTime.index((slotEndTime.startIndex), offsetBy: 10))
                            let indexStart = index2
                            
                            let indexEnd = (slotEndTime.endIndex)
                            
                            slotEndTime.removeSubrange(indexStart ..< indexEnd)
                        }
                    }
                    
                    let actualData = bodyDict["data"] as! [[String : Any]]
                    
                    // Calling the handler
                    chatHistoryHandler!(actualData, statusCode, value, slotStartTime, slotEndTime)
                }
                else
                {
                    // Calling the handler
                    chatHistoryHandler!([], 0, "0", "", "")
                }
        })
    }
    
    func subscribeRoom()
    {
        // Generating Dictionary from Model
        let authDict = [
            "authorization" : UserDefaults.standard.getToken()
        ]
        
        let params = [
            "url" : "/socket/subscribeToRoom",
            "data" : authDict
            ] as [String : Any]
        
        // Emitting the 'newMessage' event and handling the response
        socket?.emitWithAck("post", with: [params]).timingOut(after: 3, callback:
            { (dataArray) in
                
                //  self.socket?.emit("GET", with: [])
                print(dataArray)
        })
    }
    
    func receiveNotificationCount(_ messageHandler : MessageHandler?)
    {
        // self.removeIncomingMessagesListener()
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.notificationCount.rawValue, callback: { (dataArray, ack) in
            
            print(dataArray)
            
            ack.with(dataArray)
            
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary,200)
            }
        })
    }
    
    //MARK:- Receive End AppointmentTime (Listener)
    
    func endAppointmentTimeListner(_ messageHandler : MessageHandler?)
    {
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.endAppointmentTime.rawValue, callback: { (dataArray, ack) in
            print(dataArray)
            ack.with(dataArray)
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary,200)
            }
        })
    }
    
    //MARK:- Receive Enable Call Button Status (Listener)
    func receiveEnableCallButtonEvent(_ messageHandler : MessageHandler?)
    {
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.enableCallButton.rawValue, callback: { (dataArray, ack) in
            print(dataArray)
            ack.with(dataArray)
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary,200)
            }
        })
    }
    
    //MARK:- Receive Message (Listener)
    func receiveIncomingMessages(_ messageHandler : MessageHandler?)
    {
        self.removeIncomingMessagesListener()
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.newMessage.rawValue, callback: { (dataArray, ack) in
            
            print(dataArray)
            
            ack.with(dataArray)
            
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary,200)
            }
        })
    }
    
    //MARK:- Update Doctor Status (Listener)
    func updateDoctorStatus(_ messageHandler : MessageHandler?)
    {
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.updateDoctorStatus.rawValue, callback: { (dataArray, ack) in
            
            print(dataArray)
            
            ack.with(dataArray)
            
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary,200)
            }
        })
    }
    
    func removeIncomingMessagesListener()
    {
        if isSocketConnected() {
            socket?.off(SocketListenerKeywords.newMessage.rawValue)
        }
    }
    
    func removeNextAppointmentFiveEvent()
    {
        if isSocketConnected() {
            socket?.off(SocketListenerKeywords.nextAppointmentFive.rawValue)
        }
    }
    
    func nextAppointmentFiveEvent(_ messageHandler : MessageHandler?)
    {
        self.removeNextAppointmentFiveEvent()
        
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.nextAppointmentFive.rawValue, callback: { (dataArray, ack) in
            
            print("next appointment five dict => ", dataArray)
            
            ack.with(dataArray)
            
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary, 200)
            }
        })
    }
    
    func removeDoctorDeclineCallEvent()
    {
        if isSocketConnected() {
            socket?.off(SocketListenerKeywords.doctorDeclineCall.rawValue)
        }
    }
    
    func doctorDeclineCallEvent(_ messageHandler : MessageHandler?)
    {
        self.removeDoctorDeclineCallEvent()
        
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.doctorDeclineCall.rawValue, callback: { (dataArray, ack) in
            
            print("doctor decline call dict => ", dataArray)
            
            ack.with(dataArray)
            
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary, 200)
            }
        })
    }
    
    func removeDoctorAcceptedEvent()
    {
        if isSocketConnected() {
            socket?.off(SocketListenerKeywords.doctorAcceptedCall.rawValue)
        }
    }
    
    func doctorAcceptedEvent(_ messageHandler : MessageHandler?)
    {
        self.removeDoctorAcceptedEvent()
        
        if messageHandler == nil
        {
            return;
        }
        
        socket?.on(SocketListenerKeywords.doctorAcceptedCall.rawValue, callback: { (dataArray, ack) in
            
            print("doctor accepted dict => ", dataArray)
            
            ack.with(dataArray)
            
            // If handler is implemented
            // If returned response array has data in it, then retreiving the dictionary object
            if let responseDictionary = dataArray[0] as? [String:Any]
            {
                // Fetching the status code
                // let statusCode = responseDictionary["status"] as! Int
                
                // Fetching the data dictionary
                //let messageDict = responseDictionary["data"] as! [String:Any]
                
                // Calling the handler
                messageHandler!(responseDictionary, 200)
            }
        })
    }
}
