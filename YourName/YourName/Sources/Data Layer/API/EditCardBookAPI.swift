//
//  EditCardBookAPI.swift
//  MEETU
//
//  Created by Seori on 2022/04/06.
//

import Foundation
import Moya

struct EditCardBookAPI: ServiceAPI {
    typealias Response = Entity.Empty
    private let cardBookID: CardBookID
    private let name: String
    private let desc: String
    private let bgColorID: Int
    
    init(
        cardBookID: CardBookID,
         name: String,
         desc: String,
         bgColorID: Int
    ) {
        self.cardBookID = cardBookID
        self.name = name
        self.desc = desc
        self.bgColorID = bgColorID
    }
    
    var path: String { "/collections/\(cardBookID)" }
    var method: Method { .put }
    var task: NetworkingTask { return .requestParameters(
        parameters: [
            "name": name,
            "description": desc,
            "bgColorId": bgColorID,
        ],
        encoding: JSONEncoding.default)
    }
}
