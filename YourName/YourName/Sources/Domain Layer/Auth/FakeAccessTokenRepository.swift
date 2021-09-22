//
//  MockAuth.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

#warning("⚠️ TODO: 개발완료 후, Test Target으로 옮겨야합니다") // Booung
final class FakeAccessTokenRepository: AccessTokenRepository {
    
    var calledFetchAccessToken = false
    let dummyAccessToken = "I'm dummy token."
    var hasAccessToken: Bool = true
    
    func fetchAccessToken() -> Single<AccessToken?> {
        calledFetchAccessToken = true
        return .just(hasAccessToken ? dummyAccessToken : nil)
    }
    
}
