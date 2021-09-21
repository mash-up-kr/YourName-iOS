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
    
    func test_0번째_카드를_클릭하면_해당_카드_상세화면으로_네비게이션_합니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(MyCardListNavigation.self)
        let dummyCardList = createDummyCardList()
        self.mockMyCardRepository.stubedList = dummyCardList
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(300, sut.tapCard(at: 0)),
            .completed(400)
        ])
        testScheduler.start()
        
        // then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.push(.cardDetail(cardID: "test-0"))]))
    }
    
    func test_4번째_카드를_클릭하면_해당_카드_상세화면으로_네비게이션_합니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(MyCardListNavigation.self)
        let dummyCardList = createDummyCardList()
        self.mockMyCardRepository.stubedList = dummyCardList
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(300, sut.tapCard(at: 4)),
            .completed(400)
        ])
        testScheduler.start()
        
        // then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.push(.cardDetail(cardID: "test-4"))]))
    }
    
    private func createDummyCardList() -> [Card] {
        return [
            Card(id: "test-0"),
            Card(id: "test-1"),
            Card(id: "test-2"),
            Card(id: "test-3"),
            Card(id: "test-4"),
            Card(id: "test-5"),
            Card(id: "test-6")
        ]
    }
}
