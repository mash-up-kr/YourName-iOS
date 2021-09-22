//
//  MyCard.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

struct Card {
    let id: String
}
#warning("⚠️ TODO: 개발완료 후, Test Target으로 옮겨야합니다") // Booung
extension Card {
    static let dummyList: [Card] = [
        Card(id: "test-0"),
        Card(id: "test-1"),
        Card(id: "test-2"),
        Card(id: "test-3"),
        Card(id: "test-4"),
        Card(id: "test-5"),
        Card(id: "test-6")
    ]
}
