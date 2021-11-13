//
//  MyCard.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

struct Card: Equatable {
    let id: String?
    let name: String?
    let role: String?
    let introduce: String?
    let profileURL: String?
}
#warning("⚠️ TODO: 개발완료 후, Test Target으로 옮겨야합니다") // Booung
extension Card {
    static let dummyList: [Card] = [
        Card(
            id: "test-0",
            name: "hello world",
            role: "DEV",
            introduce: "HELLO WORLD",
            profileURL: nil
        ),
        Card(
            id: "test-1",
            name: "hello world",
            role: "DEV",
            introduce: "HELLO WORLD",
            profileURL: nil
        ),
        Card(
            id: "test-2",
            name: "hello world",
            role: "DEV",
            introduce: "HELLO WORLD",
            profileURL: nil
        ),
        Card(
            id: "test-3",
            name: "hello world",
            role: "DEV",
            introduce: "HELLO WORLD",
            profileURL: nil
        ),
        Card(
            id: "test-4",
            name: "hello world",
            role: "DEV",
            introduce: "HELLO WORLD",
            profileURL: nil
        ),
        Card(
            id: "test-5",
            name: "hello world",
            role: "DEV",
            introduce: "HELLO WORLD",
            profileURL: nil
        ),
        Card(
            id: "test-6",
            name: "hello world",
            role: "DEV",
            introduce: "HELLO WORLD",
            profileURL: nil
        )
    ]
}
