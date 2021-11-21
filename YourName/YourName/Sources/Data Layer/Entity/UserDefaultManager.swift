//
//  UserDefaultManager.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

enum UserDefaultManager {
    @UserDefault(key: "accessToken", defaultValue: nil)
    static var accessToken: String?
    
    @UserDefault(key: "refreshToken", defaultValue: nil)
    static var refreshToken: String?
}
