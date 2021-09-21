//
//  SplashViewModelTests.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

import Nimble
import RxTest
import XCTest
@testable import YourName

final class SplashViewModelTests: XCTestCase {
    
    // 🧪 System Under Test
    var sut: SplashViewModel!
    
    // 🥸 Test Double
    var fakeAccessTokenRepository: FakeAccessTokenRepository!
    var mockAuthenticationDelegate: MockAuthenticationDelegate!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        fakeAccessTokenRepository = FakeAccessTokenRepository()
        mockAuthenticationDelegate = MockAuthenticationDelegate()
        sut = SplashViewModel(accessTokenRepository: fakeAccessTokenRepository, authenticationDelegate: mockAuthenticationDelegate)
    }
    
    override func tearDownWithError() throws {
        fakeAccessTokenRepository = nil
        mockAuthenticationDelegate = nil
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func test_스플래시가_랜딩되어있는_동안_accessToken을_로드해옵니다() {
        // when
        sut.loadAccessToken()
        
        //then
        expect(self.fakeAccessTokenRepository.calledFetchAccessToken).to(beTrue())
    }
    
    func test_accessToken의_로드를_성공하면_delegate에게_accessToken을_전달하며_sign_in을_요청합니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let signInObserver = testScheduler.createObserver(Bool.self)
        let passedAccessTokenObserver = testScheduler.createObserver(AccessToken?.self)
        _ = mockAuthenticationDelegate.calledSignIn.subscribe(signInObserver)
        _ = mockAuthenticationDelegate.passedAccessToken.subscribe(passedAccessTokenObserver)
        fakeAccessTokenRepository.hasAccessToken = true

        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.loadAccessToken()),
            .completed(3000)
        ])
        testScheduler.start()

        // then
        let calledSignIns = signInObserver.events.compactMap(\.value.element)
        let passedAccessTokens = passedAccessTokenObserver.events.compactMap(\.value.element)

        expect(calledSignIns).to(equal([false, true]))
        expect(passedAccessTokens).to(equal([nil, fakeAccessTokenRepository.dummyAccessToken]))
    }
    
    func test_accessToken의_로드를_성공하면_delegate에게_not_sign_in을_요청합니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let notSignInObserver = testScheduler.createObserver(Bool.self)
        _ = mockAuthenticationDelegate.calledNotSignIn.subscribe(notSignInObserver)
        fakeAccessTokenRepository.hasAccessToken = false

        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.loadAccessToken()),
            .completed(3000)
        ])
        testScheduler.start()

        // then
        let calledSignIns = notSignInObserver.events.compactMap(\.value.element)
        expect(calledSignIns).to(equal([false, true]))
    }
}

