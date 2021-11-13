//
//  CardBookRepository.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import Foundation
import RxSwift

protocol CardBookRepository {
    func fetchAll() -> Observable<[CardBook]>
}

final class MockCardBookRepository: CardBookRepository {
    
    func fetchAll() -> Observable<[CardBook]> {
        return .just(CardBook.dummy)
    }
}


final class CardBookRepositoryImpl: CardBookRepository {
    
    func fetchAll() -> Observable<[CardBook]> {
        return .empty()
    }
    
}

struct CardBook: Equatable {
    let id: String?
    let title: String?
    let count: Int?
    let description: String?
    let backgroundColor: String?
}


extension CardBook {
    static let dummy = [
        CardBook(
            id: "1",
            title: "도감명1",
            count: 0,
            description: "설명은 딱 한줄만 설명 설명 설명 설명",
            backgroundColor: "#32FFFFF"
        ),
        CardBook(
            id: "2",
            title: "도감명2",
            count: 4,
            description: "설명은 딱 한줄만 설명 설명 설명 설명",
            backgroundColor: nil
        ),
        CardBook(
            id: "3",
            title: "도감명3",
            count: 20,
            description: "설명은 딱 한줄만 설명 설명 설명 설명",
            backgroundColor: nil
        )
    ]
}
