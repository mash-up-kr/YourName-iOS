//
//  RootViewModelTests.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/20.
//

import RxBlocking
import RxSwift
import RxTest
import XCTest
import Nimble
@testable import YourName

final class RootViewModelTests: XCTestCase {

    // 🧪 System Under Test
    var sut: RootViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RootViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func test_로그인_성공시_splash_화면이_뜬_뒤에_홈화면으로_네비게이션_합니다() {
        // given
        let expectedAccessToken = "access token"
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver(RootNavigation.self)
        _ = sut.navigation.subscribe(observer)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(1, sut.signIn(withAccessToken: expectedAccessToken)),
            .completed(2)
        ])
        testScheduler.start()
        
        // then
        let navigations = observer.events.compactMap(\.value.element)
        expect(navigations).to(equal([.present(.splash), .present(.signedIn(with: expectedAccessToken))]))
    }
    
    func test_로그인_실패시_splash_화면이_뜬_뒤에_로그인화면으로_네비게이션_합니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let observer = testScheduler.createObserver(RootNavigation.self)
        _ = sut.navigation.subscribe(observer)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(1, sut.notSignIn()),
            .completed(2)
        ])
        testScheduler.start()
        
        // then
        let navigations = observer.events.compactMap(\.value.element)
        expect(navigations).to(equal([.present(.splash), .present(.signedOut)]))
    }
}
