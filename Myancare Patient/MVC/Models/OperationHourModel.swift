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
    var slot_start_time : Int?
    var slot_end_time : Int?
    var isConfirmed : Bool?
    
    init() {
        date_utc = ""
        slot_start_time = 0
        slot_end_time = 0
        isConfirmed = false
    }
    
    
}
