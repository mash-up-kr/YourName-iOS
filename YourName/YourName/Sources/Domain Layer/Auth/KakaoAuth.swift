//
//  KakaoAuth.swift
//  YourName
//
//  Created by 송서영 on 2021/09/22.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKUser

struct KakaoAuth: OAuth {
    
    private enum KakaoAuthError: Error {
        case invalidToken
    }
    
    private let disposeBag = DisposeBag()
    
    func authorize() -> Single<OAuthResponse> {
        return Single<OAuthResponse>.create { observer in
            
            if UserApi.isKakaoTalkLoginAvailable() {  // 카카오톡이 깔려있는 경우
                UserApi.shared.loginWithKakaoTalk { response, error in
                    if let error = error {
                        observer(.error(error))
                    }
                    guard let accessToken = response?.accessToken else {
                        observer(.error(KakaoAuthError.invalidToken))
                        return
                    }
                    observer(.success(.init(accessToken: accessToken,
                                            provider: .kakao)))
                }
            } else {   // 카카오톡이 깔려있지않아서 웹뷰를 띄워야하는 경우
                UserApi.shared.loginWithKakaoAccount() { response, error in
                    if let error = error {
                        observer(.error(error))
                    }
                    guard let accessToken = response?.accessToken else {
                        observer(.error(KakaoAuthError.invalidToken))
                        return
                    }
                    observer(.success(.init(accessToken: accessToken,
                                            provider: .kakao)))
                }
            }
            return Disposables.create()
        }
    }
}
