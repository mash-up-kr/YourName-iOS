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

    // ๐งช System Under Test
    var sut: RootViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RootViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func test_๋ก๊ทธ์ธ_์ฑ๊ณต์_splash_ํ๋ฉด์ด_๋ฌ_๋ค์_ํํ๋ฉด์ผ๋ก_๋ค๋น๊ฒ์ด์_ํฉ๋๋ค() {
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
        expect(navigations).to(equal([.present(.splash, animated: false), .present(.signedIn(with: expectedAccessToken), animated: false)]))
    }
    
    func test_๋ก๊ทธ์ธ_์คํจ์_splash_ํ๋ฉด์ด_๋ฌ_๋ค์_๋ก๊ทธ์ธํ๋ฉด์ผ๋ก_๋ค๋น๊ฒ์ด์_ํฉ๋๋ค() {
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
        expect(navigations).to(equal([.present(.splash, animated: false), .present(.signedOut)]))
    }
}
