//
//  MockMyCardRepository.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

import RxSwift
import RxRelay


final class MockMyCardRepository: MyCardRepository {
    var calledFetchList = BehaviorRelay<Bool>(value: false)
    var stubedList: [Card] = []
    
    func fetchList() -> Observable<[Card]> {
        calledFetchList.accept(true)
        return .just(stubedList)
    }
}
