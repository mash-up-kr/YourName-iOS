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
    
    private let disposeBag = DisposeBag()
    
    func authorize() -> Single<OAuthResponse> {
        return Single<OAuthResponse>.create { observer in
            if UserApi.isKakaoTalkLoginAvailable() {   // 카카오톡 설치 여부 확인
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext:{ (oauthToken) in
                        observer(.success(OAuthResponse(accessToken: oauthToken.accessToken,
                                                        provider: Provider.kaKao)))
                    }, onError: {error in
                        observer(.error(error))
                    })
                .disposed(by: disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()   // 웹뷰
                    .subscribe(onNext:{ (oauthToken) in
                        observer(.success(OAuthResponse(accessToken: oauthToken.accessToken,
                                                        provider: Provider.kaKao)))
                    }, onError: {error in
                        observer(.error(error))
                    })
                    .disposed(by: disposeBag)
            }
            return Disposables.create()
        }
    }
}
