//
//  MakeCardAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation
import Moya

struct MakeCardAPI {
    
    struct Response: Decodable {
        let nameCardID: String?
        
        enum CodingKeys: String, CodingKey {
            case nameCardID = "nameCardId"
        }
    }
    
}

extension MakeCardAPI: ServiceAPI {
    
    var path: String { "/namecards" }
    
    var method: Moya.Method { .post }
    
    var task: Moya.Task { .requestPlain }
    
    var headers: [String : String]? { nil }
    
}
