//
//  ExchangeRateModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/28/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ExchangeRateModel {
    
    var id : String?
    var payment_gateway : String?
    var payment_gateway_type : String?
    var coin_amount : Int?
    var kyat_amount : Int?
    
    init() {
        id = ""
        payment_gateway = ""
        payment_gateway_type = ""
        coin_amount = 0
        kyat_amount = 0
    }
    
    func updateWithDict(_ dict : [String:Any]){
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let payment_gateway1 = dict["payment_gateway"] as? String{
            payment_gateway = payment_gateway1
        }
        
        if let payment_gateway_type1 = dict["payment_gateway_type"] as? String{
            payment_gateway_type = payment_gateway_type1
        }
        
        if let coin_amount1 = dict["coin_amount"] as? Int{
            coin_amount = coin_amount1
        }
        
        if let kyat_amount1 = dict["kyat_amount"] as? Int{
            kyat_amount = kyat_amount1
        }
    }
}
