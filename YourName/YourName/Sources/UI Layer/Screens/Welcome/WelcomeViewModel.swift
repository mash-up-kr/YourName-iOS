//
//  SignInViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

struct WelcomeViewModel {
    
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
            .subscribe { response in
                self.loginRequest(accessToken: response.accessToken,
                                   provider: response.provider)
            } onError: { error in
                //TODO: ??에러 핸들링 어떻게할건지
                print(error.localizedDescription, "error")
            }
            .disposed(by: disposeBag)
    }
}

extension WelcomeViewModel {
    private func loginRequest(accessToken: AccessToken, provider: Provider) {
        Enviorment.current.network.request(LoginAPI(accesToken: accessToken,
                                                    provider: provider))
            .compactMap { $0.accessToken }
            .subscribe(onNext: { accessToken in
                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                delegate.signIn(withAccessToken: accessToken)
            })
            .disposed(by: disposeBag)
    }
}

extension UserDefaults {
    static func setValue(_ value: Any, forKey: String) {
        
    }
}
