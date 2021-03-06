//
//  FriendCardsAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/03.
//

import Foundation

struct FriendCardsAPI: ServiceAPI {
    var path: String { "/collections/\(cardBookID)/namecards" }
    var method: Method { .get }
    var task: NetworkingTask { .requestPlain }
    
    let cardBookID: CardBookID
}
extension FriendCardsAPI {
    struct Response: Decodable {
        let list: [Entity.FriendCard]?
    }
}
