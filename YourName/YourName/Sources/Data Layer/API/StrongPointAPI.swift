//
//  TMICharacterAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation


struct StrongPointsAPI: ServiceAPI {
    var path: String { "/tmis/character" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
    
    typealias Response = [Entity.TMI]
}
