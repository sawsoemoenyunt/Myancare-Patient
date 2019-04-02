//
//  OperationHourModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class OperationHourModel {
    
    var date_utc : String?
    var slot_start_time : String?
    var slot_end_time : String?
    var isConfirmed : Bool?
    var id :String?
    
    init() {
        date_utc = ""
        slot_start_time = ""
        slot_end_time = ""
        isConfirmed = false
        id = ""
    }
    
    func updateModelUsingDict(_ dict:[String:Any]){
        if let date_utc1 = dict["date_utc"] as? String{
            date_utc = date_utc1
        }
        
        if let slot_start_time1 = dict["slot_start_time"] as? Int{
            let date = Date(milliseconds: slot_start_time1)
            slot_start_time = UtilityClass.get12Hour(date)
        }
        
        if let slot_end_time1 = dict["slot_end_time"] as? Int{
            let date = Date(milliseconds: slot_end_time1)
            slot_end_time = UtilityClass.get12Hour(date)
        }
        
        if let isConfirmed1 = dict["isConfirmed"] as? Bool{
            isConfirmed = isConfirmed1
        }
        
        if let id1 = dict["id"] as? String{
            id = id1
        }
    }
}
