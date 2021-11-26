//
//  MyNameCardsAPI.swift
//  MEETU
//
//  Created by seori on 2021/11/25.
//

import Foundation

struct MyNameCardsAPI: ServiceAPI {
    typealias Response = Entity.MyNameCard
    
    var path: String { "/namecards" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
}
