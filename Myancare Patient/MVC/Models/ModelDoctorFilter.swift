//
//  ModelDoctorFilter.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class ModelDoctorFilter
{
    var state : String?
    var district : String?
    var town : String?
    var townID : String?
    var selectedCategoryId : String?
    
    var sr_pcode : String?
    var d_pcode : String?
    var town_pcode : String?
    
    var locationArry: NSMutableArray?
    
    var name : String?
    
    init() {
        
        state = ""
        district = ""
        townID = ""
        town = ""
        selectedCategoryId = ""
        
        sr_pcode = ""
        d_pcode = ""
        town_pcode = ""
        
        name = ""
        
        locationArry = []
    }
}
