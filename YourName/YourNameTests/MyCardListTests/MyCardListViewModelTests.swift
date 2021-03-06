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
    
    // ๐งช System Under Test
    var sut: MyCardListViewModel!
    // ๐ฅธ Test Double
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
    
    func test_๋ก๋๋๋ฉด_๋ฐ์ดํฐ๋ฅผ_๋ ํฌ์งํ ๋ฆฌ๋ก๋ถํฐ_๊ฐ์ ธ์ต๋๋ค() {
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
    
    func test_๋ก๋_์๋ฃํ_0๋ฒ์งธ_์นด๋๋ฅผ_ํด๋ฆญํ๋ฉด_ํด๋น_์นด๋_์์ธํ๋ฉด์ผ๋ก_๋ค๋น๊ฒ์ด์_ํฉ๋๋ค() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(MyCardListNavigation.self)
        let dummyCardList = Card.dummyList
        self.mockMyCardRepository.stubedList = dummyCardList
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.load()),
            .next(300, sut.tapCard(at: 0)),
            .completed(400)
        ])
        testScheduler.start()
        
        // then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.push(.cardDetail(cardID: "test-0"))]))
    }
    
    func test_๋ก๋_์๋ฃํ__4๋ฒ์งธ_์นด๋๋ฅผ_ํด๋ฆญํ๋ฉด_ํด๋น_์นด๋_์์ธํ๋ฉด์ผ๋ก_๋ค๋น๊ฒ์ด์_ํฉ๋๋ค() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(MyCardListNavigation.self)
        let dummyCardList = Card.dummyList
        self.mockMyCardRepository.stubedList = dummyCardList
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.load()),
            .next(300, sut.tapCard(at: 4)),
            .completed(400)
        ])
        testScheduler.start()
        
        // then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.push(.cardDetail(cardID: "test-4"))]))
    }
    
    func test_์นด๋์ถ๊ฐ๋ฅผ_๋๋ฅด๋ฉด_์นด๋์ ์ํ๋ฉด์ผ๋ก_์ด๋ํฉ๋๋ค() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(MyCardListNavigation.self)
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapCardCreation()),
            .completed(500)
        ])
        testScheduler.start()
        
        // then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.present(.cardCreation)]))
    }
    
}
