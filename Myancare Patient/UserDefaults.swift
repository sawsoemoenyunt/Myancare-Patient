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
        case loginUserData
        case token
    }
    
    func setPushyToken(value: String){
        set(value, forKey: UserDefaultsKeys.pushyToken.rawValue)
        synchronize()
    }
    
    func getPushyToken() -> String?{
        return string(forKey: UserDefaultsKeys.pushyToken.rawValue)
    }
    
    func setLoginUserData(value: PatientModel){
        set(value, forKey: UserDefaultsKeys.loginUserData.rawValue)
        synchronize()
    }
    
    func getLoginUserData() -> String?{
        return string(forKey: UserDefaultsKeys.loginUserData.rawValue)
    }
    
    func setToken(value: String){
        set(value, forKey: UserDefaultsKeys.token.rawValue)
        synchronize()
    }
    
    func getToken() -> String?{
        return string(forKey: UserDefaultsKeys.token.rawValue)
    }
}
