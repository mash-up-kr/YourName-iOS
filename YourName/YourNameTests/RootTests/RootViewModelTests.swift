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
    
    override func setUp() {
        super.setUp()
        sut = RootViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    func test_로그인_성공시_splash_화면이_뜬_뒤에_홈화면으로_가야한다() {
        let expectedAccessToken = "access token"
        let testScheduler = TestScheduler(initialClock: 0)
        
        let observer = testScheduler.createObserver(RootNavigation.self)
        sut.navigation.subscribe(observer)
        
        _ = testScheduler.createHotObservable([
            .next(1, sut.signIn(withAccessToken: expectedAccessToken)),
            .completed(2)
        ])
        
        testScheduler.start()
        
        let navigations = observer.events.compactMap(\.value.element)
        expect(navigations).to(equal([.present(.splash), .present(.signedIn(with: expectedAccessToken))]))
    }
    
    func test_로그인_실패시_splash_화면이_뜬_뒤에_로그인화면으로_가야한다() {
        let testScheduler = TestScheduler(initialClock: 0)
        
        let observer = testScheduler.createObserver(RootNavigation.self)
        sut.navigation.subscribe(observer)
        
        _ = testScheduler.createHotObservable([
            .next(1, sut.notSignIn()),
            .completed(2)
        ])
        
        testScheduler.start()
        
        let navigations = observer.events.compactMap(\.value.element)
        expect(navigations).to(equal([.present(.splash), .present(.signedOut)]))
    }
}
