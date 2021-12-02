//
//  StrongPoint.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct StrongPoint: Equatable, Hashable {
    let id: Identifier
    let content: String
    let iconURL: URL
}
extension StrongPoint {
    static let dummy: [StrongPoint] = [StrongPoint(id: "0", content: "✋ 리더쉽", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "🔥 열정", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "🌵 끈기", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "👼 배려", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "🌪 추진력", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "🤜 자신감", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "😇 책임감", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "💙 친화력", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "👑 발표왕", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "👻 적응력", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "📝 꼼꼼함", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "💬 소통", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "😆 긍정적", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "⚡ 아이디어", iconURL: URL(string: "www.example.com")!)]
}
