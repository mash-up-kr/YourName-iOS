//
//  RootViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import RxRelay
import RxSwift

enum RootPath: Equatable {
    case splash
    case signedOut
    case signedIn(with: AccessToken)
}

typealias RootNavigation = Navigation<RootPath>

final class RootViewModel: AuthenticationDelegate {
    
    let navigation = BehaviorRelay<RootNavigation>(value: .present(.splash))
    
    func signIn(withAccessToken accessToken: AccessToken) {
        navigation.accept(.present(.signedIn(with: accessToken)))
    }
    
    func notSignIn() {
        navigation.accept(.present(.signedOut))
    }
}
