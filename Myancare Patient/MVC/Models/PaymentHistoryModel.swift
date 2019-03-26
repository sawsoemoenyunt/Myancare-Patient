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
    var coin : Int?
    var doctorName : String?
    var remarks : String?
    var manual_payment_status : String?
    var updatedAt : String?
    
    init() {
        coin = 0
        doctorName = ""
        remarks = ""
        manual_payment_status = ""
        updatedAt = ""
    }
    
    func updateUsingDictionary(_ dict:[String:Any]){
        if let coin1 = dict["coin"] as? Int{
            coin = coin1
        }
        
        if let docDict = dict["doctor"] as? NSDictionary{
            if let name = docDict.object(forKey: "name") as? String{
                doctorName = name
            }
        }
        
        if let remarks1 = dict["remarks"] as? String{
            remarks = remarks1
        }
        
        if let manual_payment_status1 = dict["manual_payment_status"] as? String{
            manual_payment_status = manual_payment_status1
        }
        
        if let updatedAt1 = dict["updatedAt"] as? String{
            updatedAt = updatedAt1
        }
    }
}
