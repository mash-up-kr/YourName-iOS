//
//  SplashViewModelTests.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

import Nimble
import XCTest

final class SplashViewModelTests: XCTestCase {
    
    // 🧪 System Under Test
    var sut: SplashViewModel!
    
    // 🥸 Mock
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
    
    func test_스플래시가_떠있는_동안_accessToken을_로드해온다() {
        // when
        sut.loadAccessToken()
        
        //then
        expect(self.fakeAccessTokenRepository.calledFetchAccessToken).to(beTrue())
    }
    
//    func test_accessToken의_로드를_성공하면_delegate에게_accessToken을_전달하며_sign_in을_요청한다() {
//        // given
//        let testScheduler = TestScheduler(initialClock: 0)
//        let calledSignInObserver = testScheduler.createObserver(Bool.self)
//        let passedAccessTokenObserver = testScheduler.createObserver(AccessToken?.self)
//        fakeAccessTokenRepository.hasAccessToken = true
//
//        // when
//        mockAuthenticationDelegate.calledSignIn.subscribe(calledSignInObserver)
//        mockAuthenticationDelegate.passedAccessToken.subscribe(passedAccessTokenObserver)
//
//        _ = testScheduler.createHotObservable([
//            .next(1, sut.loadAccessToken()),
//            .completed(2)
//        ])
//
//        testScheduler.start()
//
//        // then
//        let calledSignIns = calledSignInObserver.events.compactMap(\.value.element)
//        let passedAccessTokens = passedAccessTokenObserver.events.compactMap(\.value.element)
//
//        expect(calledSignIns).to(equal([false, true]))
//        expect(passedAccessTokens).to(equal([nil, fakeAccessTokenRepository.dummyAccessToken]))
//    }
}

import RxTest
import RxSwift
@testable import YourName

final class MockAuthenticationDelegate: AuthenticationDelegate {
    var calledSignIn = BehaviorSubject<Bool>(value: false)
    var calledNotSignIn = BehaviorSubject<Bool>(value: false)
    var passedAccessToken = BehaviorSubject<AccessToken?>(value: nil)
    
    func signIn(withAccessToken accessToken: AccessToken) {
        calledSignIn.onNext(true)
        passedAccessToken.onNext(accessToken)
    }
    
    func notSignIn() {
        calledNotSignIn.onNext(true)
    }
}
