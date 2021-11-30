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
    private let authRepository: AuthenticationRepository
    private let oauthRepository: OAuthRepository

    private let disposeBag = DisposeBag()
    
    init(delegate: AuthenticationDelegate,
         authRepository: AuthenticationRepository,
         oauthRepository: OAuthRepository) {
        self.delegate = delegate
        self.authRepository = authRepository
        self.oauthRepository = oauthRepository
    }
    
    deinit {
        print("💀 \(String(describing: self)) deinit")
    }
    
    func signIn(with provider: Provider) {

        self.oauthRepository.authorize(provider: provider)
            .flatMapLatest { [weak self] response -> Observable<Secret> in
                guard let self = self else { return .empty() }
                return self.authRepository
                    .fetch(withProviderToken: response.accessToken, provider: response.provider)
                    .compactMap { $0?.accessToken }
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
