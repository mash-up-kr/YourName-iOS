//
//  AuthRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func fetchAccessToken(withProviderToken providerToken: AccessToken, provider: Provider) -> Observable<(AccessToken)>
}

final class YourNameAuthRepository: AuthRepository {
    
    init(localStorage: LocalStorage, network: NetworkServing) {
        self.localStorage = localStorage
        self.network = network
    }
    
    func fetchAccessToken(withProviderToken providerToken: AccessToken, provider: Provider) -> Observable<(AccessToken)> {
        return network.request(LoginAPI(accessToken: providerToken, provider: provider))
            .compactMap { [weak self] response -> String? in
                guard let accessToken = response.accessToken,
                      let refreshToken = response.refreshToken,
                      let userOnboarding = response.userOnboarding else { return nil }
                self?.saveToken(accessToken: accessToken, refreshToken: refreshToken)
                return accessToken
            }
    }
    
    private func saveToken(accessToken: String, refreshToken: String) {
        self.localStorage.write(.accessToken, value: accessToken)
            .subscribe {
                print("access token save success \($0)")
            }.disposed(by: self.disposeBag)
        self.localStorage.write(.refreshToken, value: refreshToken)
            .subscribe {
                print("refresh token save success \($0)")
            }.disposed(by: self.disposeBag)
    }
    
    private let accessToken: String? = nil
    private let refreshToken: String? = nil
    
    private let network: NetworkServing
    private let localStorage: LocalStorage
    
    private let disposeBag = DisposeBag()
}
