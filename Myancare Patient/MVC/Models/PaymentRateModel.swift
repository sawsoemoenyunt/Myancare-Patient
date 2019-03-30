//
//  PaymentRateModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/30/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class PaymentRateModel {
    var _id : String?
    var gatewayType : String?
    
    init() {
        _id = ""
        gatewayType = ""
    }
    
    func updateUsingDict(_ dict:[String:Any]){
        if let id = dict["_id"] as? String{
            _id = id
        }
        
        if let gatewayType1 = dict["gatewayType"] as? String{
            gatewayType = gatewayType1
        }
    }
}
