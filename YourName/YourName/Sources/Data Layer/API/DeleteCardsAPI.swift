//
//  DeleteCardsAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/03.
//

import Foundation
import Alamofire

struct DeleteCardsAPI: ServiceAPI {
    let cardBookID: CardBookID
    let cardIDs: [NameCardID]
}
extension DeleteCardsAPI {
    var path: String { "/collections/\(cardBookID)/namecards" }
    var method: Method { .delete }
    var task: NetworkingTask { .requestParameters(parameters: ["namecardIds": cardIDs], encoding: JSONEncoding.default) }
    
    typealias Response = Entity.Empty
}
