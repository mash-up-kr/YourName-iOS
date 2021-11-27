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
            // TODO: apple auth 로 수정 필요
            OAuth = AppleAuth()
        }
        return OAuth.authorize()
    }
}
