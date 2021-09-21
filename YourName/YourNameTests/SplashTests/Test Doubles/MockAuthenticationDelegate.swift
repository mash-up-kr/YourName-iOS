//
//  MockAuthenticationDelegate.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

import RxRelay
import RxSwift
@testable import YourName

final class MockAuthenticationDelegate: AuthenticationDelegate {
    var calledSignIn = BehaviorRelay<Bool>(value: false)
    var calledNotSignIn = BehaviorRelay<Bool>(value: false)
    var passedAccessToken = BehaviorRelay<AccessToken?>(value: nil)
    
    func signIn(withAccessToken accessToken: AccessToken) {
        calledSignIn.accept(true)
        passedAccessToken.accept(accessToken)
    }
    
    func notSignIn() {
        calledNotSignIn.accept(true)
    }
}
