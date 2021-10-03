//
//  Optional+.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import Foundation

extension Optional where Wrapped == Bool {
    
    var isTrueOrNil: Bool {
        self == true || self == nil
    }
    
    var isFalseOrNil: Bool {
        self == false || self == nil
    }
    
}

extension Optional where Wrapped: Collection {
    var isEmptyOrNil: Bool {
        self?.isEmpty == true || self == nil
    }
}
