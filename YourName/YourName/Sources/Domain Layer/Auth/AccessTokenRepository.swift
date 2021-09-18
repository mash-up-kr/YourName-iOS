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
    func accessToken() -> Observable<AccessToken>
}

final class YNAccessTokenRepository: AccessTokenRepository {
    func accessToken() -> Observable<AccessToken> {
        #warning("⚠️ TODO Booung: 로직 구현 해야함")
        fatalError()
    }
}
