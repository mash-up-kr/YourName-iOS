//
//  MakeCardAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation
import Moya

struct MakeCardAPI {
    let nameCard: Entity.NameCardCreation
    
    var path: String { "/namecards" }
    var method: Moya.Method { .post }
    var task: Moya.Task {
        return .requestJSONEncodable(nameCard)
    }
}
extension MakeCardAPI: ServiceAPI {
    
    struct Response: Decodable {
        let nameCardID: NameCardID?
        
        enum CodingKeys: String, CodingKey {
            case nameCardID = "nameCardId"
        }
    }
    
}
