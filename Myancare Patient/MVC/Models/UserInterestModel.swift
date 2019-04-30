//
//  UserInterestModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/30/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class UserInterestModel{
    
    var id : String
    var title : String
    var image_url : String
    
    init() {
        id = ""
        title = ""
        image_url = ""
    }
    
    func updateModelUsingDict(dict:[String:Any]){
        
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let title1 = dict["title"] as? String{
            title = title1
        }
        
        if let imageUrl1 = dict["image_url"] as? String{
            image_url = imageUrl1
        }
    }
}
