//
//  Interest.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct Interest: Equatable {
    let content: String
}
extension Interest {
    static let dummy: [Interest] = [
        Interest(content: "🎧 음악"),
        Interest(content: "🎮 게임"),
        Interest(content: "📼 영상"),
        Interest(content: "💪 운동"),
        Interest(content: "🍗 음식"),
        Interest(content: "🍽 요리"),
        Interest(content: "☕️ 카페"),
        Interest(content: "🍺 술"),
        Interest(content: "🌿 자연"),
        Interest(content: "⛺️️ 야외활동"),
        Interest(content: "💚️ 봉사"),
        Interest(content: "✈️ 여행"),
        Interest(content: "🐶 동물"),
        Interest(content: "📱 기술"),
        Interest(content: "🎻 공연"),
        Interest(content: "🎤 덕질"),
        Interest(content: "🛍 쇼핑"),
        Interest(content: "🎨️ 예술"),
        Interest(content: "💄️ 뷰티"),
        Interest(content: "👗 패션"),
        Interest(content: "🏠 인테리어 "),
        Interest(content: "📚 독서"),
        Interest(content: "💭 만화"),
        Interest(content: "🤣 개그"),
        Interest(content: "🚗 자동차"),
        Interest(content: "🗣 외국어"),
        Interest(content: "📈 경제")
    ]
}

