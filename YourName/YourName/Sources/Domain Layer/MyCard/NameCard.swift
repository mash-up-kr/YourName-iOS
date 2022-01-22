//
//  MyCard.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

typealias NameCardID = Identifier

struct NameCard: Equatable, Hashable {
    let id: NameCardID?
    let uniqueCode: UniqueCode?
    let name: String?
    let role: String?
    let introduce: String?
    let bgColors: [String]?
    let profileURL: String?
    let idForDelete: String?
}
#warning("⚠️ TODO: 개발완료 후, Test Target으로 옮겨야합니다") // Booung
extension NameCard {
    static let dummyList: [NameCard] = [
        NameCard(id: "1",
                 uniqueCode: "eifn21i2",
            name: "김윤혜",
            role: "디자이너",
            introduce: "Hello world",
            bgColors: ["#FFF197"],
                 profileURL: nil,
                 idForDelete: nil
        ),
        NameCard(
            id: "2",
            uniqueCode: "eifn21i2",
            name: "송서영",
            role: "iOS",
            introduce: "나 송서영 개발한다....",
            bgColors: ["#FFC5C5",
                       "#FFF199",
                       "#BFFFA1"],
            profileURL: nil,
            idForDelete: nil
        ),
        NameCard(
            id: "3",
            uniqueCode: "eifn21i2",
            name: "김건회",
            role: "마피아",
            introduce: "ㅎ ㅡㅎ .....",
            bgColors: ["#FFF3A6",
                       "#CFFDBA",
                       "#B4ECFE",
                       "#FFCBFD"],
            profileURL: nil,
            idForDelete: nil
        ),
        NameCard(
            id: "4",
            uniqueCode: "eifn21i2",
            name: "주성민",
            role: "의사",
            introduce: "자힐이 짱",
            bgColors: ["#DDB3FF",
                       "#FFD1F5",
                       "#FFCFCF",
                       "#FFF4AB",
                       "#D9FFC8"],
            profileURL: nil,
            idForDelete: nil
        ),
        NameCard(
            id: "5",
            uniqueCode: "eifn21i2",
            name: "김가영",
            role: "호주 푸들 🐶",
            introduce: "호주에는 푸들이...",
            bgColors: ["#D6BFFF"],
            profileURL: nil,
            idForDelete: nil
        ),
        NameCard(
            id: "6",
            uniqueCode: "eifn21i2",
            name: "김경훈",
            role: "라이어",
            introduce: "우하하",
            bgColors: ["#FFCBFD"],
            profileURL: nil,
            idForDelete: nil
        ),
        NameCard(
            id: "7",
            uniqueCode: "eifn21i2",
            name: "이연중",
            role: "감독",
            introduce: "영상은 이렇게 오려ㅛㅎ거",
            bgColors: ["#CAADFF",
                       "#B4ECFE"],
            profileURL: nil,
            idForDelete: nil
        ),
        NameCard(
            id: "8",
            uniqueCode: "eifn21i2",
            name: "이동영",
            role: "대장",
            introduce: "동영오빠 더미데이터가 빠졌네",
            bgColors: ["#CAADFF",
                       "#B4ECFE"],
            profileURL: nil,
            idForDelete: nil
        )
    ]
}
