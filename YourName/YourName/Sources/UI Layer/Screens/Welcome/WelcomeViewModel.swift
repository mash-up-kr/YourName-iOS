//
//  SignInViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

final class WelcomeViewModel {
    
    private let delegate: AuthenticationDelegate
    private let disposeBag = DisposeBag()
    
    init(delegate: AuthenticationDelegate) {
        self.delegate = delegate
    }
    
    func signIn(with provider: Provider) {

        var auth: OAuth
        switch provider {
        case .kakao:
            auth = KakaoAuth()
        case .apple:
            //TODO: Apple Auth 로 교체 필요
            auth = KakaoAuth()
        }
        
        auth.authorize()
            .subscribe { [weak self] response in
                self?.loginRequest(accessToken: response.accessToken,
                                   provider: response.provider)
            } onError: { error in
                //TODO: ??에러 핸들링 어떻게할건지
                print(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

extension WelcomeViewModel {
    private func loginRequest(accessToken: AccessToken, provider: Provider) {
        Enviorment.current.network.request(LoginAPI(accesToken: accessToken,
                                                    provider: provider))
            .compactMap { response -> (String, String)? in
                guard let accessToken = response.accessToken,
                      let refreshToken = response.refreshToken else { return nil }
                return (accessToken, refreshToken)
            }
            .catchError({ error in
                //TODO: error핸들링
                print(error.localizedDescription)
                return .empty()
            })
            .bind(onNext: { [weak self] accessToken, refreshToken in
                UserDefaultManager.accessToken = accessToken
                UserDefaultManager.refreshToken = refreshToken
                
                self?.delegate.signIn(withAccessToken: accessToken)
            })
            .disposed(by: disposeBag)
    }
}
