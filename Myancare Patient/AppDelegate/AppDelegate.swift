//
//  AppDelegate.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/20/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Localize_Swift
import FacebookCore
import FacebookLogin
import Pushy
import IQKeyboardManagerSwift
import PKHUD
import AudioToolbox
import Sinch
import UserNotifications
import Alamofire
import PushKit
import CallKit
import Siren

var jwtTkn = ""
//var jwtTkn = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViMDU2MGUzZjg4MTdjMzg4ODE5YWY1MCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTU0MjgzNjYyfQ.ZSBCbJu1soHAGH6CGq9h0yg7pliYbSqAphMu1Hw-s9U" //akm
//let jwtTkn = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViYjg3MmZlNjhhOTExMmIwNDYyMjdkMCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTUzNzY0ODQ2fQ.YuAP4usQdaPMCrZWABHpDCTHY0XRX8r7PeNkPjt-tL8" //nmh
//let jwtTkn = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViMDU2MGUzZjg4MTdjMzg4ODE5YWY1MCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTUzMjI4Mzk5fQ.4a0POJTeBdl70PLBRomm4VVmEKrPMsDkZauClaRBDxY" //mtm

var appDelegate = UIApplication.shared.delegate
var callDuration: String = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate, SINClientDelegate, SINCallClientDelegate, SINManagedPushDelegate, SINCallDelegate {

    var window: UIWindow?
    var client: SINClient?
    var push: SINManagedPush?
    var callKitProvider : SINCallKitProvider?
    var callSin : SINCall?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //disble view constraints error messages in console
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        //change navigation bar tint color
        UINavigationBar.appearance().tintColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1) //black
       
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.mmFontBold(ofSize: 16)], for: .normal)
        
        //FB SDK
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //IQKeyboardmanager
        IQKeyboardManager.shared.enable = true
        
        // sinch work
        if let spush = Sinch.managedPush(with: SINAPSEnvironment.production)
        {
            self.push = spush
        }
        //register for voip notifications
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
//        voipRegistry.delegate = self
        
        self.push?.delegate = self
        self.push?.setDesiredPushTypeAutomatically()
        
        if UserDefaults.standard.isLoggedIn(){
            if let token = UserDefaults.standard.getToken(){
                jwtTkn = "Bearer \(token)"
            }
            updateUserData()
        }
        
        //register pushy
        registerPushyDevice()
        
        //connect socket
        SocketManagerHandler.sharedInstance().connectSocket { (dataArray, socAck) in
            print(dataArray)
            print(socAck)
        }
        
        //update user data
        if UserDefaults.standard.isLoggedIn(){
            if let userID = UserDefaults.standard.getUserData().object(forKey: "_id") as? String{
                self.initSinchClient(withUserId: userID)
            }
            updateUserData()
        }
        
        //choose screen to show first
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
//        let homeViewController =  HomeViewController(collectionViewLayout:layout)
        window?.rootViewController = StartScreenViewController()
        
        
        return true
    }
    
    /// An example on how to present your own custom alert using Siren's localized Strings and version checking cadence.
    func customAlertRulesExample() {
        let siren = Siren.shared
        // The key for using custom alerts is to set the `alertType` to `.none`.
        // The `Results` type will return localized strings for your app's custom modal presentation.
        // The `promptFrequency` allows you to customize how often Siren performs the version check before returning a non-error result back into your app, prompting your custom alert functionality.
        let rules = Rules(promptFrequency: .immediately, forAlertType: .none)
        siren.rulesManager = RulesManager(globalRules: rules)
        siren.wail(performCheck: .onDemand) { (results, kerr) in
            print(results)
        }
    }
    
    func registerNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.alert,.sound]) { (success, error) in
            if error != nil{
                return
            }
        }
    }
    
    func registerPushyDevice(){
        
        // Initialize Pushy SDK
        let pushy = Pushy(UIApplication.shared)
        
        // Register the device for push notifications
        pushy.register({ (error, deviceToken) in
            // Handle registration errors
            if error != nil {
                return print ("Registration failed: \(error!)")
            }
            
            // Print device token to console
            print("Pushy device token: \(deviceToken)")
            
            // Persist the token locally and send it to your backend later
            UserDefaults.standard.setPushyToken(value: deviceToken)
        })
        
        // Handle push notifications
        pushy.setNotificationHandler({ (data, completionHandler) in
            // Print notification payload data
            print("Received notification: \(data)")
            
            
            // Fallback message containing data payload
            var message = "\(data)"
            
            // Attempt to extract "message" key from APNs payload
            if let aps = data["aps"] as? [AnyHashable : Any] {
                if let payloadMessage = aps["alert"] as? String {
                    message = payloadMessage
                }
            }
            print("message : \(message)")
            
            self.window?.rootViewController?.navigationController?.pushViewController(NotificationListVC(), animated: true)
            
//            let content = UNMutableNotificationContent()
//            content.title = messageTitle
//            content.body = messageBody
//            content.sound = UNNotificationSound.default
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
//            let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
//
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
//                print("\(error)")
//            })
            
            // You must call this completion handler when you finish processing
            // the notification (after fetching background data, if applicable)
            completionHandler(UIBackgroundFetchResult.newData)
        })
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        SocketManagerHandler.sharedInstance().disconnectSocket()
    }

}

extension AppDelegate{
    /* ====================== Sinch Work =============================== */
    // Sinch SDK 3.12.4
    //konstantinfo02@gmail.com/konstant123
    // MARK: -  Sinch Init
    func initSinchClient(withUserId userId: String)
    {
        if !(self.client != nil)
        {
            if userId.isEmpty
            {
                
            }
            else
            {
                self.client = Sinch.client(withApplicationKey: "d68d658e-b5d6-4617-b12f-968fba671bb6", applicationSecret: "IYAVEU82qUabQ7U/ynqbsQ==", environmentHost: "clientapi.sinch.com", userId: userId)
                
                client?.delegate = self
                client?.call().delegate = self
                
                client?.setSupportCalling(true)
                client?.setSupportPushNotifications(true)
                client?.enableManagedPushNotifications()
                
                client?.start()
                
                client?.startListeningOnActiveConnection()
                
                callKitProvider = SINCallKitProvider(client: client)
            }
        }
    }
    
    func stopSinchClient()
    {
        client?.stop()
    }
    
    // MARK: -  SINManagedPushDelegate
    func managedPush(_ unused: SINManagedPush, didReceiveIncomingPushWithPayload payload: [AnyHashable: Any], forType pushType: String)
    {
        print("SINManagedPush Incoming call")
        self.handleRemoteNotification(payload)
    }
    
    func handleRemoteNotification(_ userInfo: [AnyHashable: Any])
    {
        print("Handle Remote notificaiton")
        
        if !(client != nil)
        {
            if let userId = UserDefaults.standard.getUserData().object(forKey: "_id") as? String{
                
                self.initSinchClient(withUserId: userId)
            }
        }
        
        print("userinfo Managed Push===== \(userInfo)")
        
        let dic = userInfo
        let sinchinfo = dic["sin"] as? String
        
        if sinchinfo == nil
        {
            return
        }
        
        let aps = dic[AnyHashable("sin")] as? String
        
        var dictonary:NSDictionary?
        
        if let data = aps?.data(using: String.Encoding.utf8)
        {
            do
            {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as! NSDictionary
                
                if let myDictionary = dictonary
                {
                    let dict = myDictionary["public_headers"] as! NSDictionary
                    if let val = dict["CALLER_NAME"]
                    {
                        print(val)
                        //userDefaults.set(userInfo, forKey: "sinchUserInfo")
                        userDefaults.set(myDictionary, forKey: "pushUserInfo")
                        userDefaults.synchronize()
                    }
                }
            }
            catch let error as NSError
            {
                print(error)
            }
        }
        
        _ = SINNotificationResult.self
        
        if let result = client?.relayRemotePushNotification(userInfo)
        {
            if (result.isCall()) && (result.call()?.isCallCanceled)!
            {
//                setMissedNotification()
            }
            else if (result.isCall()) && (result.call()?.isTimedOut)!
            {
//                setMissedNotification()
            }
            else
            {
                
            }
        }
    }
    
    //MARK: - Sinch Call Fire Socket Event
    func sinchSocketCallEvent(_ eventType:String, appointmentID: String)
    {
        if !SocketManagerHandler.sharedInstance().isSocketConnected()
        {
            return
        }
        
//        SocketManagerHandler.sharedInstance().manageCallSocketEvent (callDuration, eventType: eventType, appointmentID: appointmentID) { (dataDict, statusCode) in
//
//        }
    }
    
    // MARK: -  SINCallClientDelegate
    func client(_ client: SINCallClient, didReceiveIncomingCall call: SINCall)
    {
        //Find MainViewController and present CallViewController from it.
        
        print(" didReceiveIncomingCall Incoming call")
        
        if !(callKitProvider?._calls.isEmpty)!
        {
            
        }
        else
        {
            let state: UIApplication.State = UIApplication.shared.applicationState
            print("call description==== \(call)")
            
            if state == .active
            {
                callKitProvider?.reportNewIncomingCall(call)
            }
            
            callSin = call
        }
    }
    
    func client(_ client: SINCallClient, willReceiveIncomingCall call: SINCall)
    {
        print("willReceiveIncomingCall")
        callKitProvider?.reportNewIncomingCall(call)
    }
    
    // MARK: - SINClientDelegate
    func clientDidStart(_ client: SINClient)
    {
        print("Sinch client started successfully (version: \(Sinch.version()))")
        //voipRegistration()
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!)
    {
        print("Sinch client error: \(error.localizedDescription)")
    }
    
    func client(_ client: SINClient, logMessage message: String, area: String, severity: SINLogSeverity, timestamp: Date)
    {
        if severity == SINLogSeverity.critical
        {
            print("\(message)")
        }
    }
}

extension AppDelegate{
    func updateUserData(){
        let url = EndPoints.getPatient.path
        let userToken = UserDefaults.standard.getToken()
        let heads = ["Authorization":"Bearer \(userToken ?? "")"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: heads).responseJSON { (response) in
            switch response.result{
            case .success:
                let responseStatus = response.response?.statusCode
                if responseStatus == 200{
                    if let responseData = response.result.value as? [String:Any]{
                        let user = PatientModel()
                        user.updateModel(usingDictionary: responseData)
                        let info:NSDictionary = ["name":user.name!,
                                                 "wallet_balance":user.wallet_balance!,
                                                 "image_url":user.image_url!,
                                                 "height":user.height!,
                                                 "age":user.age!,
                                                 "weight":user.weight!,
                                                 "facebook_id":user.facebook_id!,
                                                 "country_code":user.country_code!,
                                                 "_id":user._id!,
                                                 "createdAt":user.createdAt!,
                                                 "gender":user.gender!,
                                                 "dob":user.dob!,
                                                 "email":user.email!,
                                                 "mobile":user.mobile!,
                                                 "blood_type":user.bloodType!,
                                                 "username":user.username!,
                                                 "updatedAt":user.updatedAt!]
                        UserDefaults.standard.setUserData(value: info)
                    }
                } else if responseStatus == 400 || responseStatus == 404{
                    print("Failed to get user data")
                }
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

//MARK:-
extension UIWindow
{
    //MARK:-
    func visibleViewController() -> UIViewController?
    {
        if let rootViewController: UIViewController  = self.rootViewController
        {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        
        return nil
    }
    
    //MARK:-
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController
    {
        if vc.isKind(of: UINavigationController.self)
        {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
        }
        else if vc.isKind(of: UITabBarController.self)
        {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        }
        else
        {
            if let presentedViewController = vc.presentedViewController
            {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            }
            else
            {
                return vc
            }
        }
    }
}

