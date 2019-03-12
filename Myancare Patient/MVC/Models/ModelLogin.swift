//
//  ModelLogin.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/12/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

//import Foundation
//
//
//class ModelLogin
//{
//    let role: String = "patient"
//    var name: String?
//    var email: String = ""
//    let country_code: String = "+95"
//    var mobile: String?
//    var changeMobile: String?
//    var iso_code: String? = "MM"
//    var gender: String = "male"
//    var age: String?
//    var dob: String?
//    var districttownID: String?
//    var degrees: String?
//    var experience: String?
//    var specializationsID: NSMutableArray?
//    var specializationsName: String?
//    var personNickName: String = ""
//    var biography: String?
//    var password: String?
//    var password_confirmation: String?
//    var stateName: String?
//    var districtName: String?
//    var townName: String?
//    var tempToken: String?
//    var voice: String?
//    var video: String?
//    var chat: String?
//    var enterdOTPValue: String?
//    var bloodGroup: String?
//    var height: String?
//    var weight: String?
//    var device_token : String?
//    var rates: NSDictionary?
//    var locationArry: NSMutableArray?
//
//    var availability : NSMutableArray?
//
//    init() {
//
//        //if userDefaults.object(forKey: "FCM_Token") != nil {
//        //    device_token = userDefaults.object(forKey: "FCM_Token") as? String
//        //} else {
//        //    device_token = ""
//        //}
//    }
//
//    func getLoginDictionary() -> [String : String]
//    {
//        let dictLogin = ["mobile" : modelSignUpProcess.mobile, "country_code" : modelSignUpProcess.country_code, "iso_code" : modelSignUpProcess.iso_code, "password"  : modelSignUpProcess.password, "role"  : modelSignUpProcess.role, "device_token" : UtilityClass.getDeviceFCMToken()!,"voip_token":UtilityClass.getDeviceAPNSToken()!]
//
//        return dictLogin as! [String : String]
//    }
//
//    func getRegisterDictionary() -> [String : Any]
//    {
//        if (modelSignUpProcess.height?.contains("'"))! {
//            modelSignUpProcess.height = modelSignUpProcess.height?.replacingOccurrences(of: "'", with: ".")
//        }
//
//        let height = Float(modelSignUpProcess.height!)
//
//        let dictLogin = [
//            "role"  : modelSignUpProcess.role,
//            "name"  : modelSignUpProcess.name!,
//            "nick_name"  : modelSignUpProcess.personNickName,
//            "email" : modelSignUpProcess.email,
//            "country_code" : modelSignUpProcess.country_code,
//            "mobile" : modelSignUpProcess.mobile!,
//            "iso_code"  : modelSignUpProcess.iso_code!,
//            "gender"  : modelSignUpProcess.gender,
//            "dob"  : modelSignUpProcess.dob!,
//            "age"  : modelSignUpProcess.age!,
//            "districttown"  : modelSignUpProcess.districttownID!,
//            "weight"  : modelSignUpProcess.weight!,
//            "height"  : height!,
//            "blood_type"  : modelSignUpProcess.bloodGroup!,
//            "password"  : modelSignUpProcess.password!,
//            "location" : modelSignUpProcess.locationArry!,
//            "device_token" : UtilityClass.getDeviceFCMToken()!,
//            "password_confirmation"  : modelSignUpProcess.password_confirmation!,
//            "voip_token":UtilityClass.getDeviceAPNSToken()!
//            ] as [String : Any]
//
//        return dictLogin
//    }
//
//    func getForgotPasswordDictionary() -> [String : String]
//    {
//        let dictLogin = ["mobile" : modelSignUpProcess.mobile, "country_code" : modelSignUpProcess.country_code, "iso_code" : modelSignUpProcess.iso_code, "role" : modelSignUpProcess.role]
//
//        return dictLogin as! [String : String]
//    }
//
//    func getPhoneNumberDataDictionary() -> [String : String]
//    {
//        let dictLogin = ["role" : modelSignUpProcess.role, "email" : modelSignUpProcess.email, "mobile" : modelSignUpProcess.mobile, "iso_code"  : modelSignUpProcess.iso_code]
//
//        return dictLogin as! [String : String]
//    }
//
//    func getChangePhoneNumberDataDictionary() -> [String : String]
//    {
//        let dictLogin = ["country_code" : modelSignUpProcess.country_code, "iso_code" : modelSignUpProcess.iso_code, "mobile" : modelSignUpProcess.changeMobile, "tmp_token"  : modelSignUpProcess.tempToken]
//
//        return dictLogin as! [String : String]
//    }
//
//    func getVerifyOTPDataDictionary() -> [String : String]
//    {
//        let dictLogin = ["tmp_token" : modelSignUpProcess.tempToken, "otp" : modelSignUpProcess.enterdOTPValue, "device_token" : UtilityClass.getDeviceFCMToken()!, "voip_token":UtilityClass.getDeviceAPNSToken()!]
//
//        return dictLogin as! [String : String]
//    }
//
//    func getVerifyOTPForgotDataDictionary() -> [String : String]
//    {
//        let dictLogin = ["tmp_token" : modelSignUpProcess.tempToken, "otp" : modelSignUpProcess.enterdOTPValue]
//
//        return dictLogin as! [String : String]
//    }
//
//    func getResetPasswordDataDictionary() -> [String : String]
//    {
//        let dictLogin = ["tmp_token" : modelSignUpProcess.tempToken, "password" : modelSignUpProcess.password, "password_confirmation" : modelSignUpProcess.password_confirmation]
//
//        return dictLogin as! [String : String]
//    }
//}
