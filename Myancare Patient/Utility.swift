//
//  Utility.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

let userDefaults = UserDefaults.standard

func getWeekdayString(weekDay: Int) -> String{
    var yourWeekday = ""
    switch weekDay {
    case 1:
        yourWeekday = "S"
    case 2:
        yourWeekday = "M"
    case 3:
        yourWeekday = "T"
    case 4:
        yourWeekday = "W"
    case 5:
        yourWeekday = "T"
    case 6:
        yourWeekday = "F"
    case 7:
        yourWeekday = "S"
    default:
        yourWeekday = ""
    }
    
    return yourWeekday
}

func getComingDates(days: Int) -> NSMutableArray {
    
    let dates = NSMutableArray()
    let calendar = Calendar.current
    
    var today = calendar.startOfDay(for: Date())
    
    for _ in 1 ... days {
        
        let day = calendar.component(.day, from: today)
        let month = calendar.component(.month, from: today)
        let year = calendar.component(.year, from: today)
        let weekday = calendar.component(.weekday, from: today)
        
        let date = NSMutableDictionary()
        
        date.setValue(day, forKey: "day")
        date.setValue(month, forKey: "month")
        date.setValue(year, forKey: "year")
        date.setValue(weekday, forKey: "weekday")
        
        dates.add(date)
        today = calendar.date(byAdding: .day, value: 1, to: today)!
    }
    
    return dates
    
}

class UtilityClass: NSObject {
    
    //MARK:- User Info ( SAVE )
    class func saveUserInfoData(userDict : [String:Any]) -> Void
    {
        let data = NSKeyedArchiver.archivedData(withRootObject: userDict)
        userDefaults.set(data, forKey: UserDefaults.UserDefaultsKeys.userInfoData.rawValue)
    }
    
    //MARK:- User Info ( GET )
    class func getUserInfoData() -> [String:Any]
    {
        let data : Data = userDefaults.object(forKey: UserDefaults.UserDefaultsKeys.userInfoData.rawValue) as! Data
        let userDict : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
        
        return userDict
    }
    
    //MARK:- User Name ( GET )
    class func getPersonName() -> String
    {
        let data : Data = userDefaults.object(forKey: UserDefaults.UserDefaultsKeys.userInfoData.rawValue) as! Data
        let userDict : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
        
        let name = userDict["username"] as! String
        
        return name
    }
    
    //MARK:- User wallet balance ( GET )
    class func getWalletBalance() -> Double
    {
        let data : Data = userDefaults.object(forKey: UserDefaults.UserDefaultsKeys.userInfoData.rawValue) as! Data
        let userDict : [String:Any] = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
        
        let balance = userDict["wallet_balance"] as! Double
        
        return balance
    }
    
    class func switchToHomeViewController(){
        //show homeViewController
        let layout = UICollectionViewFlowLayout()
        let homeViewController =  HomeViewController(collectionViewLayout:layout)
        self.changeRootViewController(with: UINavigationController(rootViewController: homeViewController))
    }
    
    //MARK:- Change RootViewController
    class func changeRootViewController(with newRootViewController : UIViewController) -> Void
    {
        guard let window = UIApplication.shared.keyWindow else{
            return
        }
        
        if let navigationController = window.rootViewController as? UINavigationController
        {
            navigationController.popToRootViewController(animated: false)
        }
        
        UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            window.rootViewController = newRootViewController
        }, completion: nil)
    }
    
    //MARK:- Change RootViewController
    class func changeRootViewControllerWithAnimation(newRootViewController : UIViewController, option: UIView.AnimationOptions) -> Void
    {
        guard let window = UIApplication.shared.keyWindow else{
            return
        }
        
        if let navigationController = window.rootViewController as? UINavigationController
        {
            navigationController.popToRootViewController(animated: false)
        }
        
        UIView.transition(with: window, duration: 0.3, options: option, animations: {
            window.rootViewController = newRootViewController
        }, completion: nil)
    }
}

