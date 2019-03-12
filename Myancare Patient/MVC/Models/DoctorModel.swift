//
//  Doctor.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class DoctorModel
{
    var doctorID : String?
    var doctorName: String?
    
    var specializations: NSArray?
    
    var districttown : NSDictionary?
    
    var imageUrl : String?
    var mobile : String?
    var gender : String?
    var iso_code : String?
    var age : String?
    var experience : String?
    var role : String?
    var isStatusUpdated : Bool?
    
    var isLikeByMe : Bool?
    
    var rate : NSDictionary?
    
    var country_code : String?
    var degrees : String?
    var biography : String?
    var dob : String?
    var formatted_number : String?
    var wallet_balance : String?
    var username : String?
    
    var isSuspended : Bool?
    var email : String?
    var nick_name : String?
    var online_status : String = ""
    
    var favorites : [String]?
    
    var avg_review = ""
    var review_count = 0
    
    var operating_hours : NSArray?
    
    var speakingLanuage:[String]?
    
    init() {
        doctorID = ""
        doctorName = ""
        specializations = []
        districttown = [:]
        imageUrl = ""
        mobile = ""
        gender = ""
        iso_code = ""
        age = ""
        experience = ""
        role = ""
        rate = [:]
        country_code = ""
        degrees = ""
        biography = ""
        dob = ""
        formatted_number = ""
        wallet_balance = ""
        username = ""
        isSuspended = false
        isStatusUpdated = false
        email = ""
        operating_hours = []
        nick_name = ""
        online_status = ""
        isLikeByMe = false
        favorites = []
        speakingLanuage = []
    }
    
    deinit {
        print("Doctor Model deinit")
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        if let speakingLan = dictionary["speakinglanguage"] as? NSArray{
            for languageDic in speakingLan{
                if let language = languageDic as? NSDictionary{
                    if let lan = language["language"] as? String {
                        speakingLanuage?.append(lan)
                    }
                }
            }
        }
        
        if let specializations1 = dictionary["specializations"] as? NSArray
        {
            specializations = specializations1
        }
        
        if let districttown1 = dictionary["districttown"] as? [String:Any]
        {
            districttown = districttown1 as NSDictionary
        }
        
        if let name1 = dictionary["name"] as? String
        {
            if name1.contains("Dr") {
                doctorName = "\(name1)"
            } else {
                doctorName = "Dr. \(name1)"
            }
        }
        
        if let mobile1 = dictionary["mobile"] as? String
        {
            mobile  = mobile1
        }
        
        if let avg_review1 = dictionary["avg_review"] as? Float
        {
            avg_review  = String(avg_review1)
        }
        
        if let review_count1 = dictionary["review_count"] as? Int
        {
            review_count  = review_count1
        }
        
        if let iso_code1 = dictionary["iso_code"] as? String
        {
            iso_code = iso_code1
        }
        
        if let gender1 = dictionary["gender"] as? String
        {
            gender = gender1
        }
        
        if let age1 = dictionary["age"] as? Int
        {
            age = String(age1)
        }
        
        if let experience1 = dictionary["experience"] as? Int
        {
            experience = String(experience1)
        }
        
        if let role1 = dictionary["role"] as? String
        {
            role = role1
        }
        
        if let rate1 = dictionary["rate"] as? [String:Any]
        {
            rate = rate1 as NSDictionary
        }
        
        if let country_code1 = dictionary["country_code"] as? String
        {
            country_code = country_code1
        }
        
        if let degrees1 = dictionary["degrees"] as? String
        {
            degrees = degrees1
        }
        
        if let biography1 = dictionary["biography"] as? String
        {
            biography = biography1
        }
        
        if let dob1 = dictionary["dob"] as? Int
        {
            dob = String(dob1)
        }
        
        if let formatted_number1 = dictionary["formatted_number"] as? String
        {
            formatted_number = formatted_number1
        }
        
        if let email1 = dictionary["email"] as? String
        {
            email = email1
        }
        
        if let isSuspended1 = dictionary["isSuspended"] as? Bool
        {
            isSuspended = isSuspended1
        }
        
        if let wallet_balance1 = dictionary["wallet_balance"] as? String
        {
            wallet_balance = wallet_balance1
        }
        
        if let username1 = dictionary["username"] as? String
        {
            username = username1
        }
        
        if let avatar_url1 = dictionary["avatar_url"] as? String
        {
            imageUrl = avatar_url1
        }
        
        if let id1 = dictionary["id"] as? String
        {
            doctorID = id1
        }
        
        if let operating_hours1 = dictionary["operating_hours"] as? [[String:Any]]
        {
            operating_hours = operating_hours1 as NSArray
        }
        
        isLikeByMe = false
        
        if let favorites1 = dictionary["favorites"] as? [String]
        {
            favorites = favorites1
            
//            isLikeByMe = false
//            
//            for likeStr in favorites!
//            {
//                if likeStr == UtilityClass.getUserIdData()
//                {
//                    isLikeByMe = true
//                }
//            }
        }
    }
}

