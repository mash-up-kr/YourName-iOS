//
//  AuthRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func requestLogin(accessToken: AccessToken, provider: Provider) -> Observable<(AccessToken, RefreshToken)>
    func requestLogout() -> Observable<Void>
    func requestResign() -> Observable<Void>
}

final class YourNameAuthRepository: AuthRepository {

    func requestLogin(accessToken: AccessToken, provider: Provider) -> Observable<(AccessToken, RefreshToken)> {
        return Environment.current.network.request(LoginAPI(accessToken: accessToken, provider: provider))
            .compactMap { response -> (String, String)? in
                guard let accessToken = response.accessToken,
                      let refreshToken = response.refreshToken else { return nil }
                return (accessToken, refreshToken)
            }
    }
    
    func requestLogout() -> Observable<Void> {
        return Environment.current.network.request(LogoutAPI())
            .mapToVoid()
    }
    
    func requestResign() -> Observable<Void> {
        return Environment.current.network.request(ResignAPI())
            .mapToVoid()
    }
}
