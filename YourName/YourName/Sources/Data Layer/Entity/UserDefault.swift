//
//  UserDefault.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

final class UserDefault {
    static let userDefaults = UserDefaults.standard
    
    static func setValue(_ value: Any, key: String) {
        // duplicate key check
        if userDefaults.object(forKey: key) != nil {
            // 이미 존재하는 경우
        }
        userDefaults.set(value, forKey: key)
    }
    
    static func 
}
