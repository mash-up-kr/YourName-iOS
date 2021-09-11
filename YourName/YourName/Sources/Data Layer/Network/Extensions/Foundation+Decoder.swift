//
//  Foundation+Decoding.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

extension JSONDecoder: Decoder {
    func decode<T: Decodable>(to type: T.Type, of data: Data) throws -> T {
        try self.decode(type, from: data)
    }
}
