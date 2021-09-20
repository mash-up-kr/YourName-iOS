//
//  SplashViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

struct SplashViewModel {
    
    let accessToken = PublishSubject<AccessToken?>()
    
    init(accessTokenRepository: AccessTokenRepository) {
        self.accessTokenRepository = accessTokenRepository
    }
    
    private func loadAccessToken() {
        accessTokenRepository.fetchAccessToken()
            .bind(to: accessToken)
            .disposed(by: disposeBag)
    }
    
    private let accessTokenRepository: AccessTokenRepository
    private let disposeBag = DisposeBag()
}
