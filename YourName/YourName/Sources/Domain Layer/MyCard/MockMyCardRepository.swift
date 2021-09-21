//
//  MockMyCardRepository.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

import RxSwift

final class MockMyCardRepository: MyCardRepository {
    var calledFetchList = BehaviorSubject<Bool>(value: false)
    var stubedList: [Card] = []
    
    func fetchList() -> Observable<[Card]> {
        calledFetchList.onNext(true)
        return .just(stubedList)
    }
}
