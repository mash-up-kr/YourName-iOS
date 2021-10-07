//
//  Personality.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct Personality: Equatable {
    let content: String
}
extension Personality {
    static let dummy: [Personality] = [
        Personality(content: "✋ 리더쉽"),
        Personality(content: "🔥 열정"),
        Personality(content: "🌵 끈기"),
        Personality(content: "👼 배려"),
        Personality(content: "🌪 추진력"),
        Personality(content: "🤜 자신감"),
        Personality(content: "😇 책임감"),
        Personality(content: "💙 친화력"),
        Personality(content: "👑 발표왕"),
        Personality(content: "👻 적응력"),
        Personality(content: "📝 꼼꼼함"),
        Personality(content: "💬 소통"),
        Personality(content: "😆 긍정적"),
        Personality(content: "⚡ 아이디어")
    ]
}
