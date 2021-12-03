//
//  Entity.CardBook.swift
//  MEETU
//
//  Created by Booung on 2021/12/01.
//

import Foundation

typealias CardBookID = Identifier

extension Entity {
    struct CardBook: Decodable {
        let id: CardBookID?
        let name: String?
        let description: String?
        let bgColor: BackgroundColor?
        let numberOfNameCards: Int?
    }
}
