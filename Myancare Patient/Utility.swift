//
//  Utility.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 2/24/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

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

