//
//  SplashViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

final class SplashViewModel {
    
    init(
        authenticationRepository: AuthenticationRepository,
        authenticationDelegate: AuthenticationDelegate
        ) {
        self.authenticationRepository = authenticationRepository
        self.authenticationDelegate = authenticationDelegate
    }
    
    func loadAccessToken() {
        authenticationRepository.fetch(option: .accessToken)
            .subscribe(onNext: { [weak self] authentication in
                guard let self = self else { return }
                if let accessToken = authentication?.accessToken {
                    self.authenticationDelegate.signIn(withAccessToken: accessToken)
                } else {
                    self.authenticationDelegate.notSignIn()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private let authenticationRepository: AuthenticationRepository
    private let authenticationDelegate: AuthenticationDelegate
    
    private let disposeBag = DisposeBag()
}
