//
//  BookAppointmentModel.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 4/3/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

class BookAppointmentModel {
    
    var old_appointment_id : String?
    var rescheduleBy : String?
    var doctor : String?
    var doctor_name : String?
    var patient : String?
    var type : String?
    var date_of_issue : String?
    var amount : Int?
    var service_fees : Int?
    var total_appointment_fees : Int?
    var slotStartTime : Int?
    var slotEndTime : Int?
    var slotStartTimeString : String?
    var slotEndTimeString : String?
    var date_of_issue_utc : String?
    var slot : String? //slot
    var reason :String?
    var booking_status : BookingStatus?
    
    init() {
        old_appointment_id = ""
        rescheduleBy = ""
        doctor = ""
        doctor_name = ""
        patient = ""
        type = ""
        date_of_issue = ""
        amount = 0
        service_fees = 0
        total_appointment_fees = 0
        slotStartTime = 0
        slotEndTime = 0
        slotStartTimeString = ""
        slotEndTimeString = ""
        date_of_issue = ""
        slot = ""
        reason = ""
        booking_status = BookingStatus.PENDING
    }
}
