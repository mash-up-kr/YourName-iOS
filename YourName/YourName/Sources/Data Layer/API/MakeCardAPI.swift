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
//        var parameters: [String: Any] = [:]
//        if let name = nameCard.name               { parameters["name"] = name               }
//        if let role = nameCard.role               { parameters["role"] = role               }
//        if let personality = nameCard.personality { parameters["personality"] = personality }
//        if let introduce = nameCard.introduce     { parameters["introduce"] = introduce     }
//        if let bgColorId = nameCard.bgColorId     { parameters["bgColorId"] = bgColorId     }
//        if let tmiIds = nameCard.tmiIds           { parameters["tmiIds"] = tmiIds           }
//        if let skills = nameCard.skills           { parameters["skills"] = skills           }
        return .requestJSONEncodable(nameCard)
//        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default) }
    }
}
extension MakeCardAPI: ServiceAPI {
    
    struct Response: Decodable {
        let nameCardID: String?
        
        enum CodingKeys: String, CodingKey {
            case nameCardID = "nameCardId"
        }
    }
    
}
