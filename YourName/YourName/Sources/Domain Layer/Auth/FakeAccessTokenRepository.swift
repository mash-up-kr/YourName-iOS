//
//  MockAuth.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

final class FakeAccessTokenRepository: AccessTokenRepository {
    
    let dummyAccessToken = "I'm dummy token."
    var hasAccessToken: Bool = true
    var calledFetchAccessToken = false
    
    func fetchAccessToken() -> Observable<AccessToken?> {
        calledFetchAccessToken = true
        return .just(hasAccessToken ? dummyAccessToken : nil)
    }
    
}
