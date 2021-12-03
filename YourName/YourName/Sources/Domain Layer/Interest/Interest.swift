//
//  Interest.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct Interest: Equatable, Hashable {
    let id: Identifier
    let content: String
    let iconURL: URL
}
extension Interest {
    static let dummy: [Interest] = [Interest(id: "0", content: "🎧 음악", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🎮 게임", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "📼 영상", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "💪 운동", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🍗 음식", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🍽 요리", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "☕️ 카페", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🍺 술", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🌿 자연", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "⛺️️ 야외활동", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "💚️ 봉사", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "✈️ 여행", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🐶 동물", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "📱 기술", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🎻 공연", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🎤 덕질", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🛍 쇼핑", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🎨️ 예술", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "💄️ 뷰티", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "👗 패션", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🏠 인테리어 ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "📚 독서", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "💭 만화", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🤣 개그", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🚗 자동차", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "🗣 외국어", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "📈 경제", iconURL: URL(string: "www.example.com")!)]
}
