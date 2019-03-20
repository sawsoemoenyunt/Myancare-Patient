//
//  PatientModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class PatientModel {
    
    var token : String?
    
    var createdAt : String?
    var updatedAt : String?
    var username : String?
    var dob : String?
    var mobile : String?
    var gender : String?
    var email : String?
    var height : Double?
    var weight : Double?
    var bloodType : String?
    var wallet_balance : Double?
    var age : Double?
    var avatar : String?
    var avatarUrl : String?
    
    init(){
        createdAt = ""
        updatedAt = ""
        username = ""
        dob = ""
        mobile = ""
        gender = ""
        email = ""
        height = 0
        weight = 0
        bloodType = ""
        wallet_balance = 0
        age = 0
        avatar = ""
        avatarUrl = ""
    }
    
    deinit {
        print("Patient Model deinit")
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void {

        if let createdAt1 = dictionary["createdAt"] as? String{
            createdAt = createdAt1
        }
        
        if let updatedAt1 = dictionary["updatedAt"] as? String{
            updatedAt = updatedAt1
        }
        
        if let username1 = dictionary["username"] as? String{
            username  = username1
        }
        
        if let dob1 = dictionary["dob"] as? String{
            dob  = dob1
        }
        
        if let mobile1 = dictionary["mobile"] as? String{
            mobile  = mobile1
        }
        
        if let gender1 = dictionary["gender"] as? String{
            gender  = gender1
        }
        
        if let email1 = dictionary["email"] as? String{
            email  = email1
        }
        
        if let height1 = dictionary["height"] as? Double{
            height  = height1
        }
        
        if let weight1 = dictionary["weight"] as? Double{
            weight = weight1
        }
        
        if let bloodType1 = dictionary["blood_type"] as? String{
            bloodType = bloodType1
        }
        
        if let walletBalance = dictionary["wallet_balance"] as? Double{
            wallet_balance  = walletBalance
        }
        
        if let age1 = dictionary["age"] as? Double{
            age = age1
        }
        
        if let bloodType1 = dictionary["blood_type"] as? String{
            bloodType = bloodType1
        }
        
        if let avatar1 = dictionary["avatar"] as? String{
            avatar = avatar1
        }
        
        if let avatar_url = dictionary["avatar_url"] as? String{
            avatarUrl = avatar_url
        }
    }
}
