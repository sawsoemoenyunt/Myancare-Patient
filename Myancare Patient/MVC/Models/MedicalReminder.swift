//
//  MedicalReminder.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/31/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class MedicalReminderModel {
    
    var id : String?
    var title : String?
    var drug_name : String?
    var drug_for : String?
    var type : String?
    var frequency : Int?
    var from_date : String?
    var to_date : String?
    var frequency_time : [String]?
    var user_id : String?
    var createdAt : String?
    var updatedAt : String?
    
    init() {
        id = ""
        title = ""
        drug_name = ""
        drug_for = ""
        type = ""
        frequency = 0
        from_date = ""
        to_date = ""
        frequency_time = [String]()
        user_id = ""
        createdAt = ""
        updatedAt = ""
    }
    
    func updateModelUsingDict(_ dict:[String:Any]){
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let title1 = dict["title"] as? String{
            title = title1
        }
        
        if let drug_name1 = dict["drug_name"] as? String{
            drug_name = drug_name1
        }
        
        if let drug_for1 = dict["for"] as? String{
            drug_for = drug_for1
        }
        
        if let type1 = dict["type"] as? String{
            type = type1
        }
        
        if let frequency1 = dict["frequency"] as? Int{
            frequency = frequency1
        }
        
        if let from_date1 = dict["from_date"] as? String{
            from_date = from_date1
        }
        
        if let to_date1 = dict["to_date"] as? String{
            to_date = to_date1
        }
        
        if let frequency_time1 = dict["frequency_time"] as? [String]{
            frequency_time = frequency_time1
        }
        
        if let user_id1 = dict["user_id"] as? String{
            user_id = user_id1
        }
        
        if let createdAt1 = dict["createdAt"] as? String{
            createdAt = createdAt1
        }
        
        if let updatedAt1 = dict["updatedAt"] as? String{
            updatedAt = updatedAt1
        }
    }
}
