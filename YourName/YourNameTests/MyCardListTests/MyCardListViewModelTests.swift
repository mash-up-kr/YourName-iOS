//
//  MyCardListViewModelTests.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

import Nimble
import RxTest
import XCTest
@testable import YourName

final class MyCardListViewModelTests: XCTestCase {

    // 🧪 System Under Test
    var sut: MyCardListViewModel!
    // 🥸 Test Double
    var mockMyCardRepository: MockMyCardRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.mockMyCardRepository = MockMyCardRepository()
        self.sut = MyCardListViewModel(myCardRepository: mockMyCardRepository)
    }
    
    override func tearDownWithError() throws {
        self.mockMyCardRepository = nil
        self.sut = nil
        
        try super.tearDownWithError()
    }
    
    func test_로드되면_데이터를_레포지토리로부터_가져옵니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let calledFetchListObserver = testScheduler.createObserver(Bool.self)
        _ = mockMyCardRepository.calledFetchList.subscribe(calledFetchListObserver)
        
        // when
            _ = testScheduler.createHotObservable([
                .next(300, sut.load()),
                .completed(500)
            ])
        testScheduler.start()
        
        // then
        let calledFetchList = calledFetchListObserver.events.compactMap(\.value.element)
        expect(calledFetchList).to(equal([false, true]))
    }
    
}
