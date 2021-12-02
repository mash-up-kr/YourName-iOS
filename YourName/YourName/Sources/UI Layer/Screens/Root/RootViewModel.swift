//
//  RootViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import RxRelay
import RxSwift

enum RootDestination: Equatable {
    case splash
    case signedOut
    case signedIn(accessToken: Secret, refreshToken: Secret)
}

typealias RootNavigation = Navigation<RootDestination>

final class RootViewModel: AuthenticationDelegate {
    
    let navigation = BehaviorRelay<RootNavigation>(value: .present(.splash, animated: false))
    
    func signIn(accessToken: Secret, refreshToken: Secret) {
        navigation.accept(.present(.signedIn(accessToken: accessToken, refreshToken: refreshToken),
                                   animated: false))
    }
    
    func notSignIn() {
        navigation.accept(.present(.signedOut))
    }
}
