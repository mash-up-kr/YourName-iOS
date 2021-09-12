//
//  HTTP.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

enum HTTP {
    typealias Headers = [String: String]
    typealias Parameters = [String: String]
    
    struct Method: RawRepresentable, Equatable {
        static let get = HTTP.Method(rawValue: "GET")!
        static let post = HTTP.Method(rawValue: "POST")!
        static let put = HTTP.Method(rawValue: "PUT")!
        static let delete = HTTP.Method(rawValue: "DELETE")!
        static let patch = HTTP.Method(rawValue: "PATCH")!
        
        typealias RawValue = String
        var rawValue: String
        
        init?(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
