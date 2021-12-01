//
//  CardBooksAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/01.
//

import Foundation

struct CardBooksAPI: ServiceAPI {
    
    var path: String { "/collections" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
}
extension CardBooksAPI {
    
    struct Response: Decodable {
        let list: [Entity.CardBook]?
    }
}
