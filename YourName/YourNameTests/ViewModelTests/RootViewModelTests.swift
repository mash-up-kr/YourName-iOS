//
//  RootViewModelTests.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/20.
//

import RxSwift
import RxTest
import XCTest
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
        let dummyAccessToken = "access token"
        let disposeBag = DisposeBag()
        
        let testScheduler = TestScheduler(initialClock: 0)
        
        let navigations = testScheduler.start(
            created: 0,
            subscribed: 0,
            disposed: 3000,
            create: { self.sut.navigation }
        ).events.map { $0.value.element }
        
        sut.signIn(withAccessToken: dummyAccessToken)
    }
    
    func test_로그인_실패시_splash_화면이_뜬_뒤에_로그인화면으로_가야한다() {
        let testScheduler = TestScheduler(initialClock: 0)
        
        let navigations = testScheduler.start(
            created: 0,
            subscribed: 0,
            disposed: 3000,
            create: { self.sut.navigation }
        ).events.map { $0.value.element }
        
        sut.notSignIn()
        XCTAssertEqual(navigations, [.present(.splash), .present(.signedOut)])
    }
}
