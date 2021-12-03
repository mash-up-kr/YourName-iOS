//
//  YNBackgroundColor.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation

extension Entity {
    
    struct BackgroundColor: Codable {
        let id: Identifier?
        let value: [String]?
        var isLock: Bool?
    }
    
}

