//
//  MedicationReminderModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class MedicationReminderModel
{
    var meditationId : String!
    var drug_name : String?
    var medication_for : String?
    var frequencyString : String?
    var from_date : String?
    var start_time : String?
    var to_date : String?
    var type : String?
    
    var frequency : Int?
    
    var user : [String : Any]?
    
    var frequency_time_long : [String]?
    
    init()
    {
        meditationId = ""
        drug_name = ""
        medication_for = ""
        frequencyString = ""
        from_date = ""
        start_time = ""
        to_date = ""
        type = ""
        
        frequency = 0
        
        user = [:]
        
        frequency_time_long = []
    }
    
    deinit
    {
        print("MedicationReminder Model deinit")
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        if let id = dictionary["id"] as? String
        {
            meditationId = id
        }
        
        if let drug_name1 = dictionary["drug_name"] as? String
        {
            drug_name = drug_name1
        }
        
        if let medication_for1 = dictionary["for"] as? String
        {
            medication_for = medication_for1
        }
        
        if let type1 = dictionary["type"] as? String
        {
            type = type1
        }
        
        if let frequency1 = dictionary["frequency"] as? Int
        {
            frequency = frequency1
            frequencyString = "\(frequency ?? 0) Hr"
        }
        
        if let user1 = dictionary["user"] as? [String : Any]
        {
            user = user1
        }
        
        if let frequency_time_long1 = dictionary["frequency_time_long"] as? [Int]
        {
            let frequency_time_long2 = frequency_time_long1
            
            for longData1 in frequency_time_long2
            {
                var longData = String(longData1)
                //print(longData)
                
                if (longData.count) > 10 {
                    
                    let index2 = (longData.index((longData.startIndex), offsetBy: 10))
                    let indexStart = index2
                    
                    let indexEnd = (longData.endIndex)
                    
                    longData.removeSubrange(indexStart ..< indexEnd)
                }
                
                let date1 = UtilityClass.getDateStringFromTimeStamp3(timeStamp: longData)
                
                frequency_time_long?.append(date1 as String)
            }
        }
        
        if let from_date_long1 = dictionary["from_date_long"] as? Int
        {
            from_date = String(from_date_long1)
            
            if (from_date?.count)! > 10 {
                
                let index2 = (from_date?.index((from_date?.startIndex)!, offsetBy: 10))
                let indexStart = index2!
                
                let indexEnd = (from_date?.endIndex)!
                
                from_date?.removeSubrange(indexStart ..< indexEnd)
            }
            
            let date1 = UtilityClass.getDateStringFromTimeStamp2(timeStamp: from_date!)
            
            from_date = date1 as String
        }
        
        if let start_time_long1 = dictionary["start_time_long"] as? Int
        {
            start_time = String(start_time_long1)
            
            if (start_time?.count)! > 10 {
                
                let index2 = (start_time?.index((start_time?.startIndex)!, offsetBy: 10))
                let indexStart = index2!
                
                let indexEnd = (start_time?.endIndex)!
                
                start_time?.removeSubrange(indexStart ..< indexEnd)
            }
            
            let date = Date(timeIntervalSince1970: Double(Int(start_time!)!) )
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            
            dateFormatter.timeZone = NSTimeZone.system
            
            //12-Sep-2017 | 10:00 AM
            dateFormatter.dateFormat = "hh:mm aa" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            
            start_time = strDate as String
        }
        
        if let to_date_long = dictionary["to_date_long"] as? Int
        {
            to_date = String(to_date_long)
            
            if (to_date?.count)! > 10 {
                
                let index2 = (to_date?.index((to_date?.startIndex)!, offsetBy: 10))
                let indexStart = index2!
                
                let indexEnd = (to_date?.endIndex)!
                
                to_date?.removeSubrange(indexStart ..< indexEnd)
            }
            
            let date1 = UtilityClass.getDateStringFromTimeStamp2(timeStamp: to_date!)
            
            to_date = date1 as String
        }
    }
}
