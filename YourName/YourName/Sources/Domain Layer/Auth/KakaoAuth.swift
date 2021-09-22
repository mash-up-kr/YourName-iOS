//
//  KakaoAuth.swift
//  YourName
//
//  Created by 송서영 on 2021/09/22.
//

import Foundation
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser

struct KakaoAuth: OAuth {
    private typealias SingleObserver = (SingleEvent<OAuthResponse>) -> Void
    private let disposeBag = DisposeBag()
    
    func authorize() -> Single<OAuthResponse> {
        return Single<OAuthResponse>.create { observer in
            if UserApi.isKakaoTalkLoginAvailable() {
                self.loginWithKakaoTalk(observer: observer)
            } else {
                loginWithWebView(observer: observer)
            }
            return Disposables.create()
        }
    }
    
    private func loginWithKakaoTalk(observer: @escaping SingleObserver) {
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext: { oauthToken in
                observer(.success(OAuthResponse(accessToken: oauthToken.accessToken,
                                                provider: .kakao)))
            }, onError: {error in
                observer(.error(error))
            })
        .disposed(by: disposeBag)
    }
    
    private func loginWithWebView(observer: @escaping SingleObserver) {
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(onNext: { oauthToken in
                observer(.success(OAuthResponse(accessToken: oauthToken.accessToken,
                                                provider: .kakao)))
            }, onError: {error in
                observer(.error(error))
            })
            .disposed(by: disposeBag)
    }
}
