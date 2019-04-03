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
    
    class func getHeads()->[String:Any]{
        return ["Authorization":"\(jwtTkn)"]
    }
    
    class func get24Hour(_ date:Date) -> String{
        let hour = Calendar.current.component(.hour, from: date)
        let min = Calendar.current.component(.minute, from: date)
        return "\(String(format: "%02d", hour)) : \(String(format: "%02d", min))"
    }
    
    class func get12Hour(_ date:Date) -> String{
        let fm = DateFormatter()
        fm.dateFormat = "h:mm a"
        return fm.string(from: date)
    }
    
    class func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    //MARK:- Extract Number
    class func extractNumber(fromString string:String) -> String
    {
        let characterSet = CharacterSet.decimalDigits.inverted
        let stringArray = string.components(separatedBy: characterSet)
        let newString = stringArray.joined(separator: "")
        return newString
    }
    
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

