//
//  MeetuResponse.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation

struct MeetuResponse<Wrapped: Decodable>: Decodable {
    let statusCode: Int?
    let data: Wrapped?
    let message: String?
    
    
}
