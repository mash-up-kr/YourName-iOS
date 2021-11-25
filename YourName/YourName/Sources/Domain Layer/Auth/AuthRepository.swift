//
//  AuthRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func requestLogin(accessToken: AccessToken, provider: Provider) -> Observable<(AccessToken)>
}

final class YourNameAuthRepository: AuthRepository {

    func requestLogin(accessToken: AccessToken, provider: Provider) -> Observable<(AccessToken)> {
        return Environment.current.network.request(LoginAPI(accessToken: accessToken, provider: provider))
            .compactMap { response -> String? in
                guard let accessToken = response.accessToken,
                      let refreshToken = response.refreshToken,
                      let userOnboarding = response.userOnboarding else { return nil }
                
                UserDefaultManager.accessToken = accessToken
                UserDefaultManager.refreshToken = refreshToken
                return accessToken
            }
    }
}
