//
//  LoginPasscodeVC.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import UIKit

class LoginPasscodeVC: PasscodeVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        titleString = "Enter Passcode"
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //9 = cancel && 11 = delete
        if indexPath.item == 9 {
            dialedNumbersDisplayString = ""
            
        } else if indexPath.item == 11{
            dialedNumbersDisplayString = String(dialedNumbersDisplayString.dropLast())
            
        } else {
            let number = numbers[indexPath.item]
            
            if dialedNumbersDisplayString.count < 4{
                dialedNumbersDisplayString += number
                collectionView.reloadData()
                
                if dialedNumbersDisplayString.count == 4{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.validatePassword()
                    }
                }
            }
        }
        
        collectionView.reloadData()
    }
    
    func validatePassword(){
        var savedPassword = ""
        
        if let password = UserDefaults.standard.getLoginPsscode(){
            savedPassword = password
        }
        
        if dialedNumbersDisplayString == savedPassword{
            UtilityClass.switchToHomeViewController()
            
        } else {
            print("Wrong Password")
        }
        
        dialedNumbersDisplayString = ""
        collectionView.reloadData()
    }
}
