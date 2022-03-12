//
//  DeleteCardBookAPI.swift
//  MEETU
//
//  Created by Seori on 2022/03/12.
//

import Foundation

struct DeleteCardBookAPI: ServiceAPI {
    typealias Response = Entity.Empty
    private let cardBookID: CardBookID
    
    init(cardBookID: CardBookID) {
        self.cardBookID = cardBookID
    }
    
    var path: String { "/collections/\(self.cardBookID)" }
    var method: Method { .delete }
    var task: NetworkingTask {
        return .requestPlain
    }
}

