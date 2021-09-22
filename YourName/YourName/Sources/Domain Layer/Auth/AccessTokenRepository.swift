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

final class YourNameAccessTokenRepository: AccessTokenRepository {
    func fetchAccessToken() -> Observable<AccessToken?> {
        #warning("⚠️ TODO: 로직 구현 해야함") // Booung
        fatalError()
    }
}
