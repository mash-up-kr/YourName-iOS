//
//  UserDefault.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T?
    
    var wrappedValue: T? {
        get { UserDefaults.standard.object(forKey: key) as? T }
        set { UserDefaults.standard.set(defaultValue, forKey: key )}
    }
}
