//
//  DoctorListModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/26/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class DoctorListModel{
    
    var online_status : Bool?
    var name : String?
    var image_url : String?
    var id : String?
    var specialization : String?
    
    init() {
        online_status = false
        name = ""
        image_url = ""
        id = ""
        specialization = ""
    }
    
    func updateDoctorListModel(_ dict:[String:Any]){
        if let online_status1 = dict["online_status"] as? Bool{
            online_status = online_status1
        }
        
        if let name1 = dict["name"] as? String{
            name = name1
        }
        
        if let image_url1 = dict["image_url"] as? String{
            image_url = image_url1
        }
        
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let specialization1 = dict["specialization"] as? String{
            specialization = specialization1
        }
    }
}
