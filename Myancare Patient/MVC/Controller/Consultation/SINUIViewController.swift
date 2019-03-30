//
//  SINUIViewController.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/30/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit
import Sinch

var sin_deferredDismissalKey = ""

class SINUIViewController: UIViewController {
    
    /// Bool Variable To CHek Is Appearing
    private(set) var isAppearing = false
    /// Bool Variable To CHek Is Disapperaing
    private(set) var isDisappearing = false
    
    /// UIViewController Life Cycle Methods
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        if view.window == nil
        {
            isAppearing = false
            isDisappearing = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        isAppearing = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        isAppearing = false
        dismissIfNecessary()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        isDisappearing = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        isAppearing = false
    }
    
    // MARK: - Dismissal
    func dismiss()
    {
        if isDisappearing
        {
            return
        }
        else if isAppearing
        {
            setShouldDeferredDismiss(true)
            return
        }
        
        dismiss(animated: true) {() -> Void in }
    }
    
    func dismissIfNecessary()
    {
        if shouldDeferrDismiss()
        {
            setShouldDeferredDismiss(false)
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.dismiss()
            })
        }
    }
    
    func shouldDeferrDismiss() -> Bool
    {
        return sin_getAssociatedBOOL(forKey: sin_deferredDismissalKey)
    }
    
    func setShouldDeferredDismiss(_ v: Bool)
    {
        sin_setAssociatedBOOL(v, forKey: sin_deferredDismissalKey)
    }
    
    // MARK: -
    func sin_getAssociatedBOOL(forKey key: UnsafeRawPointer) -> Bool
    {
        let v = objc_getAssociatedObject(self, key) as? NSNumber
        return (v != nil) ? (v != 0) : false
    }
    
    func sin_setAssociatedBOOL(_ v: Bool, forKey key: UnsafeRawPointer)
    {
        objc_setAssociatedObject(self, key, (v ? 1 : 0), .OBJC_ASSOCIATION_COPY)
    }
}
