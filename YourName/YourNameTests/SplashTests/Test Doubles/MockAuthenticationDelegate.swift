//
//  MockAuthenticationDelegate.swift
//  YourNameTests
//
//  Created by Booung on 2021/09/21.
//

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
