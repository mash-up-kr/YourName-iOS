//
//  Interest.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct Interest: Equatable, Hashable {
    let id: Int
    let content: String
}
extension Interest {
    static let dummy: [Interest] = [
        Interest(id: 0, content: "🎧 음악"),
        Interest(id: 0, content: "🎮 게임"),
        Interest(id: 0, content: "📼 영상"),
        Interest(id: 0, content: "💪 운동"),
        Interest(id: 0, content: "🍗 음식"),
        Interest(id: 0, content: "🍽 요리"),
        Interest(id: 0, content: "☕️ 카페"),
        Interest(id: 0, content: "🍺 술"),
        Interest(id: 0, content: "🌿 자연"),
        Interest(id: 0, content: "⛺️️ 야외활동"),
        Interest(id: 0, content: "💚️ 봉사"),
        Interest(id: 0, content: "✈️ 여행"),
        Interest(id: 0, content: "🐶 동물"),
        Interest(id: 0, content: "📱 기술"),
        Interest(id: 0, content: "🎻 공연"),
        Interest(id: 0, content: "🎤 덕질"),
        Interest(id: 0, content: "🛍 쇼핑"),
        Interest(id: 0, content: "🎨️ 예술"),
        Interest(id: 0, content: "💄️ 뷰티"),
        Interest(id: 0, content: "👗 패션"),
        Interest(id: 0, content: "🏠 인테리어 "),
        Interest(id: 0, content: "📚 독서"),
        Interest(id: 0, content: "💭 만화"),
        Interest(id: 0, content: "🤣 개그"),
        Interest(id: 0, content: "🚗 자동차"),
        Interest(id: 0, content: "🗣 외국어"),
        Interest(id: 0, content: "📈 경제")
    ]
}
