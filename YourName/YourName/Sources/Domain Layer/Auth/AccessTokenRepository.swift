//
//  YNAuth.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

typealias AccessToken = String

protocol AccessTokenRepository {
    func fetchAccessToken() -> Observable<AccessToken?>
}

struct YourNameAccessTokenRepository: AccessTokenRepository {
    func fetchAccessToken() -> Observable<AccessToken?> {
        Observable<AccessToken?>.create { observer in
            observer.onNext(UserDefaultManager.accessToken)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
