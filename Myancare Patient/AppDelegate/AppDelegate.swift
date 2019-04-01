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

let jwtTkn = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViMDU2MGUzZjg4MTdjMzg4ODE5YWY1MCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTUzOTQ0ODE3fQ.4lWrKiJZ0m5TRkOsOjKHascSBm4l4p3hwQ3Y0JkCVqE" //akm
//let jwtTkn = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViYjg3MmZlNjhhOTExMmIwNDYyMjdkMCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTUzNzY0ODQ2fQ.YuAP4usQdaPMCrZWABHpDCTHY0XRX8r7PeNkPjt-tL8" //nmh
//let jwtTkn = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViMDU2MGUzZjg4MTdjMzg4ODE5YWY1MCIsInJvbGUiOiJQYXRpZW50IiwiaWF0IjoxNTUzMjI4Mzk5fQ.4a0POJTeBdl70PLBRomm4VVmEKrPMsDkZauClaRBDxY" //mtm

var appDelegate = UIApplication.shared.delegate
var callDuration: String = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UICollectionViewDelegateFlowLayout {

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
        
        //register pushy
        registerPushyDevice()
        
        //connect socket
        //connect socket
        SocketManagerHandler.sharedInstance().connectSocket { (dataArray, socAck) in
            print(dataArray)
            print(socAck)
        }
        
        //choose screen to show first
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
//        let layout = UICollectionViewFlowLayout()
//        let homeViewController =  HomeViewController(collectionViewLayout:layout)
        window?.rootViewController = StartScreenViewController()
        
        return true
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
            
            // Display the notification as an alert
            let alert = UIAlertController(title: "Incoming Notification", message: message, preferredStyle: UIAlertController.Style.alert)
            
            // Add an action button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // Show the alert dialog
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            
            // Play notification sound (cute tweet noise)
            AudioServicesPlaySystemSound(1016)
            
            // Vibrate the device
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
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

