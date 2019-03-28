//
//  SpecializationModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/28/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class SpecializationModel{
    
    var id : String?
    var name : String?
    var name_my : String?
    var image : String?
    var slug : String?
    
    init() {
        id = ""
        name = ""
        name_my = ""
        image = ""
        slug = ""
    }
    
    func updateModelUsingDict(_ dict:[String:Any]){
        
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let name1 = dict["name"] as? String{
            name = name1
        }
        
        if let name_my1 = dict["name_my"] as? String{
            name_my = name_my1
        }
        
        if let image1 = dict["image"] as? String{
            image = image1
        }
        
        if let slug1 = dict["slug"] as? String{
            slug = slug1
        }
    }
}
