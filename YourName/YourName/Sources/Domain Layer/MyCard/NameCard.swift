//
//  MyCard.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

struct NameCard: Equatable, Hashable {
    let id: String?
    let name: String?
    let role: String?
    let introduce: String?
    let bgColors: [String]?
    let profileURL: String?
}
#warning("⚠️ TODO: 개발완료 후, Test Target으로 옮겨야합니다") // Booung
extension NameCard {
    static let dummyList: [NameCard] = [
        NameCard(
            id: "test-0",
            name: "김윤혜",
            role: "디자이너",
            introduce: "Hello world",
            bgColors: ["#FFF197"],
            profileURL: nil
        ),
        NameCard(
            id: "test-1",
            name: "송서영",
            role: "iOS",
            introduce: "나 송서영 개발한다....",
            bgColors: ["#FFB9AA"],
            profileURL: nil
        ),
        NameCard(
            id: "test-2",
            name: "김건회",
            role: "마피아",
            introduce: "ㅎ ㅡㅎ .....",
            bgColors: ["#B4ECFE"],
            profileURL: nil
        ),
        NameCard(
            id: "test-3",
            name: "주성민",
            role: "의사",
            introduce: "자힐이 짱",
            bgColors: ["#D6BFFF"],
            profileURL: nil
        ),
        NameCard(
            id: "test-4",
            name: "김가영",
            role: "호주 푸들 🐶",
            introduce: "호주에는 푸들이...",
            bgColors: ["#D6BFFF"],
            profileURL: nil
        ),
        NameCard(
            id: "test-5",
            name: "김경훈",
            role: "라이어",
            introduce: "우하하",
            bgColors: ["#FFCBFD"],
            profileURL: nil
        ),
        NameCard(
            id: "test-6",
            name: "이연중",
            role: "감독",
            introduce: "영상은 이렇게 오려ㅛㅎ거",
            bgColors: ["#CFFDBA"],
            profileURL: nil
        )
    ]
}
