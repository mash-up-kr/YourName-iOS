//
//  CardBook.swift
//  MEETU
//
//  Created by Booung on 2021/11/14.
//

import Foundation

struct CardBook: Equatable {
    let id: Identifier?
    let title: String?
    let count: Int?
    let description: String?
    let backgroundColor: [String]?
}


extension CardBook {
    
    static let `default` = CardBook(
        id: nil,
        title: "전체 앨범",
        count: 0,
        description: "",
        backgroundColor:  nil
    )
    
    static let dummy = [
        CardBook(id: "0", title: "전체 앨범", count: 0, description: "설명은 딱 한줄만 설명 설명 설명 설명", backgroundColor:  nil),
        CardBook(id: "1", title: "도감명1", count: 0, description: "설명은 딱 한줄만 설명 설명 설명 설명", backgroundColor: ["#CFFDBA"]),
        CardBook(id: "2", title: "도감명2", count: 4, description: "설명은 딱 한줄만 설명 설명 설명 설명", backgroundColor: ["#B4ECFE"]),
        CardBook(id: "3", title: "도감명3", count: 20, description: "설명은 딱 한줄만 설명 설명 설명 설명", backgroundColor: ["#DDB3FF", "#FFD1F5", "#FFCFCF", "#FFF4AB", "#D9FFC8"])
    ]
}
