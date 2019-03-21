//
//  UserDefaults.swift
//  Myancare Patient
//
//  Created by SawSMN's MacBook Pro on 3/18/19.
//  Copyright © 2019 Saw Soe Moe Nyunt. All rights reserved.
//

import Foundation

extension UserDefaults{
    enum UserDefaultsKeys: String {
        case pushyToken
        case token
        case userInfoData
        case isLoggedIn
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setPushyToken(value: String){
        set(value, forKey: UserDefaultsKeys.pushyToken.rawValue)
        synchronize()
    }
    
    func getPushyToken() -> String?{
        return string(forKey: UserDefaultsKeys.pushyToken.rawValue)
    }
    
    func setToken(value: String){
        set(value, forKey: UserDefaultsKeys.token.rawValue)
        synchronize()
    }
    
    func getToken() -> String?{
        return string(forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func setUserData(value: NSDictionary) {
        set(value, forKey: UserDefaultsKeys.userInfoData.rawValue)
        synchronize()
    }
    
    func getUserData() -> NSDictionary {
        return object(forKey: UserDefaultsKeys.userInfoData.rawValue) as! NSDictionary
    }
}
