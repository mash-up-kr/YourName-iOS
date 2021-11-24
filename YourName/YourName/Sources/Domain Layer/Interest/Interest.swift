//
//  Interest.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct Interest: Equatable {
    let id: String
    let content: String
}
extension Interest {
    static let dummy: [Interest] = [
        Interest(id: UUID().uuidString, content: "🎧 음악"),
        Interest(id: UUID().uuidString, content: "🎮 게임"),
        Interest(id: UUID().uuidString, content: "📼 영상"),
        Interest(id: UUID().uuidString, content: "💪 운동"),
        Interest(id: UUID().uuidString, content: "🍗 음식"),
        Interest(id: UUID().uuidString, content: "🍽 요리"),
        Interest(id: UUID().uuidString, content: "☕️ 카페"),
        Interest(id: UUID().uuidString, content: "🍺 술"),
        Interest(id: UUID().uuidString, content: "🌿 자연"),
        Interest(id: UUID().uuidString, content: "⛺️️ 야외활동"),
        Interest(id: UUID().uuidString, content: "💚️ 봉사"),
        Interest(id: UUID().uuidString, content: "✈️ 여행"),
        Interest(id: UUID().uuidString, content: "🐶 동물"),
        Interest(id: UUID().uuidString, content: "📱 기술"),
        Interest(id: UUID().uuidString, content: "🎻 공연"),
        Interest(id: UUID().uuidString, content: "🎤 덕질"),
        Interest(id: UUID().uuidString, content: "🛍 쇼핑"),
        Interest(id: UUID().uuidString, content: "🎨️ 예술"),
        Interest(id: UUID().uuidString, content: "💄️ 뷰티"),
        Interest(id: UUID().uuidString, content: "👗 패션"),
        Interest(id: UUID().uuidString, content: "🏠 인테리어 "),
        Interest(id: UUID().uuidString, content: "📚 독서"),
        Interest(id: UUID().uuidString, content: "💭 만화"),
        Interest(id: UUID().uuidString, content: "🤣 개그"),
        Interest(id: UUID().uuidString, content: "🚗 자동차"),
        Interest(id: UUID().uuidString, content: "🗣 외국어"),
        Interest(id: UUID().uuidString, content: "📈 경제")
    ]
}
