//
//  MedicalRecordSheetModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/4/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class MedicalRecordSheetModel{
    
    var id : String?
    var imageLink : String?
    var record_sheed : NSArray?
    
    init() {
        id = ""
        imageLink = ""
        record_sheed = NSArray()
    }
    
    func updateModelUsingDict(_ dict:[String:Any]){
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let image_link1 = dict["image_link"] as? String{
            imageLink = image_link1
        }
        
        if let record_sheed1 = dict["record_sheed"] as? NSArray{
            record_sheed = record_sheed1
        }
    }
}
