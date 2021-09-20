//
//  RootViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

enum RootPath {
    case splash
    case signedOut
    case signedIn(with: AccessToken)
}

typealias RootNavigation = Navigation<RootPath>

final class RootViewModel: AuthenticationDelegate {
    
    let navigation = BehaviorSubject<RootNavigation>(value: .present(.splash))
    
    func signIn(withAccessToken accessToken: AccessToken) {
        navigation.onNext(.present(.signedIn(with: accessToken)))
    }
    
    func notSignIn() {
        navigation.onNext(.present(.signedOut))
    }
}
