//
//  QuestMeta.swift
//  MEETU
//
//  Created by Booung on 2021/11/27.
//

import Foundation

enum QuestMeta: String, Decodable {
    case makeFirstNameCard
    case saveMeetuMyAlbum
    case addFriendNameCard
    case makeFirstCardBook = "makeNewCollection"
    case makeThreeNameCards
    
    var title: String {
        switch self {
        case .makeFirstNameCard: return "나의 첫 미츄 만들기"
        case .saveMeetuMyAlbum: return "나의 명함 사진첩에 저장하기"
        case .addFriendNameCard: return "친구 미츄 추가하기"
        case .makeFirstCardBook: return "새로운 도감 만들기"
        case .makeThreeNameCards: return "미츄 3개 이상 만들기"
        }
    }
}

