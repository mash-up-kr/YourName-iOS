//
//  ImageUploadAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/01.
//

import Foundation

struct ImageUploadAPI: ServiceAPI {
    typealias Response = Entity.Empty
    
    var path: String   { "/images" }
    var method: Method { .post }
}
