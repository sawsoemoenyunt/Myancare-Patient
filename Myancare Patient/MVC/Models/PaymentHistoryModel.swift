//
//  PaymentHistoryModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class PaymentHistoryModel
{
    var paymentID : String = ""
    var amount : String = ""
    var type : String = ""
    var remarks : String = ""
    var service_type : String = ""
    var dateString : String = ""
    
    var transaction_status = ""
    var description = ""
    
    var status : Bool = false
    
    var is_refund : Bool = false
    
    var user : [String : Any] = [:]
    var to_doctor : [String : Any] = [:]
    var coin :String = ""
    
    init()
    {
        paymentID = ""
        amount = ""
        type = ""
        remarks = ""
        service_type = ""
        dateString = ""
        transaction_status = ""
        description = ""
        coin = ""
        
        status = false
        is_refund = false
        
        user = [:]
        to_doctor = [:]
    }
    
    deinit
    {
        print("PaymentHistory Model deinit")
    }
    
    func updateModel(usingDictionary dictionary:[String:Any]) -> Void
    {
        if let id = dictionary["id"] as? String
        {
            paymentID = id
        }
        
        if let amount1 = dictionary["amount"] as? Double
        {
            let amount2 = NSString(format : "%.2f", amount1)
            amount = String(amount2)
            var amount1 = "Coin".localized() as NSString
            amount1 = amount1.appending(" \(amount)") as NSString
            amount = amount1 as String
        }
        if let coin1 = dictionary["coin"] as? Double
        {
            coin = "Coin \(Int(coin1)) "
        }
        
        if let remarks1 = dictionary["remarks"] as? String
        {
            remarks = remarks1
        }
        
        if let service_type1 = dictionary["service_type"] as? String
        {
            service_type = service_type1
        }
        
        if let status1 = dictionary["status"] as? Bool
        {
            status = status1
        }
        
        if let user1 = dictionary["user"] as? [String : Any]
        {
            user = user1
        }
        
        if let to_doctor1 = dictionary["to_doctor"] as? [String : Any]
        {
            to_doctor = to_doctor1
        }
        
        if let dob1 = dictionary["created"] as? Int
        {
            dateString = String(dob1)
            
            if (dateString.count) > 10
            {
                let index2 = (dateString.index((dateString.startIndex), offsetBy: 10))
                let indexStart = index2
                
                let indexEnd = (dateString.endIndex)
                
                dateString.removeSubrange(indexStart ..< indexEnd)
            }
            
//            let date1 = UtilityClass.getDateStringFromTimeStamp1(timeStamp: dateString)
//            
//            dateString = date1 as String
        }
        
        if let type1 = dictionary["is_refund"] as? Bool
        {
            is_refund = type1
        }
        
        if let type1 = dictionary["type"] as? String
        {
            type = type1
            
            if type == "credit"
            {
                if service_type == ""
                {
                    description = "Top up wallet".localized()
                }
                else
                {
                    if is_refund == true
                    {
                        description = "Refund".localized()
                    }
                    else
                    {
                        description = "Refund".localized()
                    }
                }
            }
            else
            {
                var drName = to_doctor["name"] as! String
                if drName.contains("Dr. ")
                {
                    drName = drName.replacingOccurrences(of: "Dr. ", with: "")
                }
                
                if drName.contains("Dr.")
                {
                    drName = drName.replacingOccurrences(of: "Dr.", with: "")
                }
                
                var description1 = "Consultation with Dr.".localized() as NSString
                description1 = description1.appending(" \(drName)") as NSString
                description = description1 as String
            }
        }
        
        if let transaction_status1 = dictionary["transaction_status"] as? String
        {
            if description == "Top up wallet".localized()
            {
                transaction_status = transaction_status1
                
                if transaction_status.contains("_")
                {
                    transaction_status = transaction_status.replacingOccurrences(of: "_", with: " ")
                }
                
                transaction_status = transaction_status.capitalized
            }
            else
            {
                transaction_status = ""
            }
        }
    }
}
