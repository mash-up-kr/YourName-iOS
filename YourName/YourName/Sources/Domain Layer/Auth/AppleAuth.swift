//
//  AppleAuth.swift
//  MEETU
//
//  Created by KimKyungHoon on 2021/11/27.
//

import Foundation
import RxSwift
import RxOptional
import AuthenticationServices


struct AppleAuth: OAuth {
    func authorize() -> Observable<OAuthResponse> {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.performRequests()
        return controller.rx.accessTokenDidLoad
          .map { identityToken in
            guard let identityToken = identityToken else { throw Error.tokenDidNotFetched }
              
              return OAuthResponse(accessToken: identityToken, provider: .apple)
          }.first().asObservable().filterNil()
    }
    
    enum Error: LocalizedError {
      case tokenDidNotFetched

      var errorDescription: String? { "애플과 연결을 실패했습니다." }
    }
}
