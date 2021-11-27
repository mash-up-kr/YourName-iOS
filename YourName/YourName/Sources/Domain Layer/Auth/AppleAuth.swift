//
//  AppleAuth.swift
//  MEETU
//
//  Created by KimKyungHoon on 2021/11/27.
//

import Foundation
import RxSwift
import AuthenticationServices


struct AppleAuth: OAuth {
    func authorize() -> Observable<OAuthResponse> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.performRequests()
        return controller.rx.accessTokenDidLoad
          .map { accessToken in
            guard let accessToken = accessToken else { throw Error.tokenDidNotFetched }
              return OAuthResponse(accessToken: accessToken, provider: .apple)
          }
    }
    
    enum Error: LocalizedError {
      case tokenDidNotFetched

      var errorDescription: String? { "애플과 연결을 실패했습니다." }
    }
}
