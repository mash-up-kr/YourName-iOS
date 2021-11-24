//
//  StrongPoint.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct StrongPoint: Equatable {
    let id: String
    let content: String
}
extension StrongPoint {
    static let dummy: [StrongPoint] = [
        StrongPoint(id: UUID().uuidString, content: "✋ 리더쉽"),
        StrongPoint(id: UUID().uuidString, content: "🔥 열정"),
        StrongPoint(id: UUID().uuidString, content: "🌵 끈기"),
        StrongPoint(id: UUID().uuidString, content: "👼 배려"),
        StrongPoint(id: UUID().uuidString, content: "🌪 추진력"),
        StrongPoint(id: UUID().uuidString, content: "🤜 자신감"),
        StrongPoint(id: UUID().uuidString, content: "😇 책임감"),
        StrongPoint(id: UUID().uuidString, content: "💙 친화력"),
        StrongPoint(id: UUID().uuidString, content: "👑 발표왕"),
        StrongPoint(id: UUID().uuidString, content: "👻 적응력"),
        StrongPoint(id: UUID().uuidString, content: "📝 꼼꼼함"),
        StrongPoint(id: UUID().uuidString, content: "💬 소통"),
        StrongPoint(id: UUID().uuidString, content: "😆 긍정적"),
        StrongPoint(id: UUID().uuidString, content: "⚡ 아이디어")
    ]
}
