//
//  MedicalRecordBookModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/2/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class MedicalRecordBookModel{
    
    var id : String?
    var doctor_id : String?
    var hospital_name : String?
    var doctor_name : String?
    var description : String?
    var patient_id : String?
    var createdAt : String?
    
    init() {
        id = ""
        doctor_id = ""
        hospital_name = ""
        doctor_name = ""
        description = ""
        patient_id = ""
    }
    
    func updateModelUsingDict(_ dict:[String:Any]){
        if let id1 = dict["id"] as? String{
            id = id1
        }
        
        if let doctor_id1 = dict["doctor_id"] as? String{
            doctor_id = doctor_id1
        }
        
        if let hospital_name1 = dict["hospital_name"] as? String{
            hospital_name = hospital_name1
        }
        
        if let doctor_name1 = dict["doctor_name"] as? String{
            doctor_name = doctor_name1
        }
        
        if let description1 = dict["description"] as? String{
            description = description1
        }
        
        if let patient_id1 = dict["patient_id"] as? String{
            patient_id = patient_id1
        }
        
        if let createdAt1 = dict["createdAt"] as? String{
            createdAt = createdAt1
        }
    }
}
