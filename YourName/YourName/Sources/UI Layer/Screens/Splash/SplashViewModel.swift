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
        accessTokenRepository: AccessTokenRepository,
        authenticationDelegate: AuthenticationDelegate
        ) {
        self.accessTokenRepository = accessTokenRepository
        self.authenticationDelegate = authenticationDelegate
    }
    
    func loadAccessToken() {
        #warning("⚠️ TODO: Delay Code 삭제") // Booung
        accessTokenRepository.fetchAccessToken()
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] accessToken in
                guard let self = self else { return }
                if let accessToken = accessToken {
                    self.authenticationDelegate.signIn(withAccessToken: accessToken)
                } else {
                    self.authenticationDelegate.notSignIn()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private let accessTokenRepository: AccessTokenRepository
    private let authenticationDelegate: AuthenticationDelegate
    
    private let disposeBag = DisposeBag()
}
