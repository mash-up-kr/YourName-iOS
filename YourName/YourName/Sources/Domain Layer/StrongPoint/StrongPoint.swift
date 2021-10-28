//
//  StrongPoint.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct StrongPoint: Equatable {
    let content: String
}
extension StrongPoint {
    static let dummy: [StrongPoint] = [
        StrongPoint(content: "✋ 리더쉽"),
        StrongPoint(content: "🔥 열정"),
        StrongPoint(content: "🌵 끈기"),
        StrongPoint(content: "👼 배려"),
        StrongPoint(content: "🌪 추진력"),
        StrongPoint(content: "🤜 자신감"),
        StrongPoint(content: "😇 책임감"),
        StrongPoint(content: "💙 친화력"),
        StrongPoint(content: "👑 발표왕"),
        StrongPoint(content: "👻 적응력"),
        StrongPoint(content: "📝 꼼꼼함"),
        StrongPoint(content: "💬 소통"),
        StrongPoint(content: "😆 긍정적"),
        StrongPoint(content: "⚡ 아이디어")
    ]
}
