//
//  SignInViewModel.swift
//  YourName
//
//  Created by 송서영 on 2021/09/18.
//

import Foundation
import RxSwift
import RxRelay

final class WelcomeViewModel {
    
    private let delegate: AuthenticationDelegate
    private let authRepository: AuthRepository
    private let OAuthRepository: OAuthRepository

    private let disposeBag = DisposeBag()
    
    init(delegate: AuthenticationDelegate,
         authRepository: AuthRepository,
         OAuthRepository: OAuthRepository) {
        self.delegate = delegate
        self.authRepository = authRepository
        self.OAuthRepository = OAuthRepository
    }
    
    deinit {
        print("💀 \(String(describing: self)) deinit")
    }
    
    func signIn(with provider: Provider) {

        self.OAuthRepository.authorize(provider: provider)
            .asObservable()
            .flatMapLatest { [weak self] response -> Observable<AccessToken> in
                guard let self = self else { return .empty() }
                return self.authRepository.requestLogin(accessToken: response.accessToken,
                                                        provider: response.provider)
            }
            .catchError({ error in
                return .empty()
            })
            .bind(onNext: { [weak self] accessToken in
                self?.delegate.signIn(withAccessToken: accessToken)
            })
            .disposed(by: disposeBag)
    }
}
