//
//  ProfileModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ProfileModel
{
    var specializations : [[String : Any]]?
    var transactions : [[String : Any]]?
    var appointments : [[String : Any]]?
    var bookings : [[String : Any]]?
    
    var location : [[Double]]?
    
    var districttown : [String : Any]?
    
    var name : String?
    var email : String?
    var mobile : String?
    var formatted_number : String?
    var iso_code : String?
    var gender : String?
    var age : String?
    var role : String?
    var height : String?
    var blood_type : String?
    var country_code : String?
    var weight : String?
    var nick_name : String?
    var dob : String?
    var device_os : String?
    var degrees : String?
    var wallet_balance : String?
    var username : String?
    var avatar_url : String?
    
    var notification_setting : Bool?
    var online_status : Bool?
    
    var patientID : String?
    
    init()
    {
        patientID = ""
        name = ""
        email = ""
        mobile = ""
        iso_code = ""
        gender = ""
        age = ""
        role = ""
        height = ""
        blood_type = ""
        country_code = ""
        weight = ""
        nick_name = ""
        dob = ""
        degrees = ""
        wallet_balance = ""
        username = ""
        avatar_url = ""
        
        notification_setting = false
        online_status = false
        
        districttown = [:]
        
        specializations = []
        transactions = []
        appointments = []
        bookings = []
        location = []
    }
    
    deinit
    {
        print("Profile Model deinit")
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        //print("dictionary = \(dictionary)")
        
        if let id = dictionary["id"] as? String
        {
            patientID = id
        }
        
        if let name1 = dictionary["name"] as? String
        {
            name = name1
        }
        
        if let age1 = dictionary["age"] as? Int
        {
            age = String(age1)
        }
        
        if let dob1 = dictionary["dob"] as? Int
        {
            dob = String(dob1)
            
            if (dob?.count)! > 10 {
                
                let index2 = (dob?.index((dob?.startIndex)!, offsetBy: 10))
                let indexStart = index2!
                
                let indexEnd = (dob?.endIndex)!
                
                dob?.removeSubrange(indexStart ..< indexEnd)
            }
            
//            let date1 = UtilityClass.getDateStringFromTimeStamp2(timeStamp: dob!)
//            
//            dob = date1 as String
        }
        
        if let degrees1 = dictionary["degrees"] as? String
        {
            degrees = degrees1
        }
        
        if let email1 = dictionary["email"] as? String
        {
            email = email1
        }
        
        if let avatar_url1 = dictionary["avatar_url"] as? String
        {
            avatar_url = avatar_url1
        }
        
        if let gender1 = dictionary["gender"] as? String
        {
            gender = gender1
        }
        
        if let iso_code1 = dictionary["iso_code"] as? String
        {
            iso_code = iso_code1
        }
        
        if let mobile1 = dictionary["mobile"] as? Int
        {
            mobile = String(mobile1)
        }
        
        if let blood_type1 = dictionary["blood_type"] as? String
        {
            blood_type = blood_type1
        }
        
        if let country_code1 = dictionary["country_code"] as? String
        {
            country_code = country_code1
        }
        
        if let wallet_balance1 = dictionary["wallet_balance"] as? Double
        {
            let wallet_balance2 = NSString(format : "%.2f", wallet_balance1)
            wallet_balance = String(wallet_balance2)
        }
        
        if let role1 = dictionary["role"] as? String
        {
            role = role1
        }
        
        if let username1 = dictionary["username"] as? String
        {
            username = username1
        }
        
        if let device_os1 = dictionary["device_os"] as? String
        {
            device_os = device_os1
        }
        
        if let height1 = dictionary["height"] as? Double
        {
            let heightDecimal = Double(round(100*height1)/100)
            height = String(heightDecimal)
            if (height?.contains("."))! {
                height = height?.replacingOccurrences(of: ".", with: "'")
            }
        }
        
        if let weight1 = dictionary["weight"] as? Int
        {
            weight = String(weight1)
        }
        
        if let nick_name1 = dictionary["nick_name"] as? String
        {
            nick_name = nick_name1
        }
        
        if let notification_setting1 = dictionary["notification_setting"] as? Bool
        {
            notification_setting = notification_setting1
        }
        
        if let online_status1 = dictionary["online_status"] as? Bool
        {
            online_status = online_status1
        }
        
        if let districttown1 = dictionary["districttown"] as? [String:Any]
        {
            districttown = districttown1
        }
        
        if let specializations1 = dictionary["specializations"] as? [[String:Any]]
        {
            specializations = specializations1
        }
        
        if let transactions1 = dictionary["transactions"] as? [[String:Any]]
        {
            transactions = transactions1
        }
        
        if let appointments1 = dictionary["appointments"] as? [[String:Any]]
        {
            appointments = appointments1
        }
        
        if let bookings1 = dictionary["bookings"] as? [[String:Any]]
        {
            bookings = bookings1
        }
        
        if let location1 = dictionary["location"] as? [[Double]]
        {
            location = location1
        }
        
        if let phNumber = dictionary["formatted_number"] as? String
        {
            formatted_number = phNumber
        }
    }
}
