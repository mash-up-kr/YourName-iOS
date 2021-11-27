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


final class YourNameCardBookRepository: CardBookRepository {
    
    func fetchAll() -> Observable<[CardBook]> {
        return .empty()
    }
    
}
