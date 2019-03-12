//
//  Utility.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit


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

