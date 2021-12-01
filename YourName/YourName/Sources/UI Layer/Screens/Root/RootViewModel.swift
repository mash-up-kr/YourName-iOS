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
    case signedIn(with: Secret)
}

typealias RootNavigation = Navigation<RootDestination>

final class RootViewModel: AuthenticationDelegate {
    
    let navigation = BehaviorRelay<RootNavigation>(value: .present(.splash, animated: false))
    
    func signIn(withAccessToken accessToken: Secret) {
        navigation.accept(.present(.signedIn(with: accessToken), animated: false))
    }
    
    func notSignIn() {
        navigation.accept(.present(.signedOut))
    }
}
