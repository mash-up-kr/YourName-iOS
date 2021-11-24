//
//  StrongPoint.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct StrongPoint: Equatable, Hashable {
    let id: Int
    let content: String
}
extension StrongPoint {
    static let dummy: [StrongPoint] = [
        StrongPoint(id: 0, content: "✋ 리더쉽"),
        StrongPoint(id: 0, content: "🔥 열정"),
        StrongPoint(id: 0, content: "🌵 끈기"),
        StrongPoint(id: 0, content: "👼 배려"),
        StrongPoint(id: 0, content: "🌪 추진력"),
        StrongPoint(id: 0, content: "🤜 자신감"),
        StrongPoint(id: 0, content: "😇 책임감"),
        StrongPoint(id: 0, content: "💙 친화력"),
        StrongPoint(id: 0, content: "👑 발표왕"),
        StrongPoint(id: 0, content: "👻 적응력"),
        StrongPoint(id: 0, content: "📝 꼼꼼함"),
        StrongPoint(id: 0, content: "💬 소통"),
        StrongPoint(id: 0, content: "😆 긍정적"),
        StrongPoint(id: 0, content: "⚡ 아이디어")
    ]
}
