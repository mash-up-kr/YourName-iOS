//
//  MockMyCardRepository.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

import RxSwift
import RxRelay

#warning("⚠️ TODO: 개발완료 후, Test Target으로 옮겨야합니다") // Booung
final class MockMyCardRepository: MyCardRepository {
    var calledFetchList = BehaviorRelay<Bool>(value: false)
    var stubedList: [Card] = []
    
    func fetchList() -> Observable<[Card]> {
        calledFetchList.accept(true)
        return .just(stubedList)
    }
}
