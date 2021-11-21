//
//  UserDefault.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    
    var wrappedValue: Value? {
        get { UserDefaults.standard.object(forKey: key) as? Value }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
