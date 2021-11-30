//
//  OAuthRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import RxSwift

protocol OAuthRepository {
    func authorize(provider: Provider) -> Observable<OAuthResponse>
}

final class YourNameOAuthRepository: OAuthRepository {
    func authorize(provider: Provider) -> Observable<OAuthResponse> {
        var OAuth: OAuth
        switch provider {
        case .kakao:
            OAuth = KakaoAuth()
        case .apple:
            OAuth = AppleAuth()
        }
        return OAuth.authorize()
    }
}
