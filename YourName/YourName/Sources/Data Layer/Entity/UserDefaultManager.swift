//
//  UserDefaultManager.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

enum UserDefaultManager {
    @UserDefault<String>(key: "accessToken")
    static var accessToken: String?
    
    @UserDefault<String>(key: "refreshToken")
    static var refreshToken: String?
}
