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
    var online_status : Bool?
    var name : String?
    var degrees : String?
    var experience : Int?
    var biography : String?
    var specialization : String?
    var language : NSArray?
    var image_url : String?
    var id : String?
    var chat : Bool?
    var video : Bool?
    var voice : Bool?
    var favorite : Bool?
    
    init() {
        online_status = false
        name = ""
        degrees = ""
        experience = 0
        biography = ""
        specialization = ""
        language = NSArray()
        image_url = ""
        id = ""
        chat = false
        video = false
        voice = false
        favorite = false
    }
    
    func updateUsingDict(_ dict:[String:Any]){
        
        if let online_status1 = dict["online_status"] as? Bool{
            online_status = online_status1
        }
        
        if let name1 = dict["name"] as? String{
            name = name1
        }
        
        if let degrees1 = dict["degrees"] as? String{
            degrees = degrees1
        }
        
        if let experience1 = dict["experience"] as? Int{
            experience = experience1
        }
        
        if let biography1 = dict["biography"] as? String{
            biography = biography1
        }
        
        if let specialization1 = dict["specialization"] as? String{
            specialization = specialization1
        }
        
        if let specialization2 = dict["specialization"] as? NSDictionary{
            if let specname = specialization2.object(forKey: "name") as? String{
                specialization = specname
            }
        }
        
        if let languageArray = dict["language"] as? NSArray{
            language = languageArray
        }
        
        if let image_url1 = dict["image_url"] as? String{
            image_url = image_url1
        }
        
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let chat1 = dict["chat"] as? Bool{
            chat = chat1
        }
        
        if let voice1 = dict["voice"] as? Bool{
            voice = voice1
        }
        
        if let video1 = dict["video"] as? Bool{
            video = video1
        }
        
        if let favorite1 = dict["favorite"] as? Bool{
            favorite = favorite1
        }
    }
}

