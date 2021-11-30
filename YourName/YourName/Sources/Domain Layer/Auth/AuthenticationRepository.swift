//
//  AuthRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import RxSwift

protocol AuthenticationRepository {
    
    func fetch() -> Observable<Authentication?>
    
    func fetch(withProviderToken providerToken: Secret, provider: Provider) -> Observable<Authentication?>
}

final class YourNameAuthenticationRepository: AuthenticationRepository {
    
    init(localStorage: LocalStorage, network: NetworkServing) {
        self.localStorage = localStorage
        self.network = network
    }
    
    func fetch() -> Observable<Authentication?> {
        return Observable.zip(
            self.localStorage.read(.accessToken),
            self.localStorage.read(.refreshToken)
        ).map { accessToken, refreshToken in
            Authentication(accessToken: accessToken, refreshToken: refreshToken, user: nil, userOnboarding: nil)
        }
    }
    
    func fetch(withProviderToken providerToken: Secret, provider: Provider) -> Observable<Authentication?> {
        return network.request(LoginAPI(accessToken: providerToken, provider: provider))
            .compactMap { [weak self] authentication -> Authentication? in
                if let accessToken = authentication.accessToken     { self?.save(accessToken: accessToken)   }
                if let refreshToken = authentication.refreshToken   { self?.save(refreshToken: refreshToken) }
                
                return authentication
            }
    }
    
    private func save(accessToken: String) {
        self.localStorage.write(.accessToken, value: accessToken)
            .subscribe { print("access token save success \($0)") }
            .disposed(by: self.disposeBag)
    }
    
    private func save(refreshToken: String) {
        self.localStorage.write(.refreshToken, value: refreshToken)
            .subscribe { print("refresh token save success \($0)") }
            .disposed(by: self.disposeBag)
    }
    
    private let accessToken: String? = nil
    private let refreshToken: String? = nil
    
    private let network: NetworkServing
    private let localStorage: LocalStorage
    
    private let disposeBag = DisposeBag()
}
