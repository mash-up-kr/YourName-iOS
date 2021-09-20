//
//  MockAuth.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

final class FakeAccessTokenRepository: AccessTokenRepository {
    
    var hasAccessToken: Bool = true
    
    func fetchAccessToken() -> Observable<AccessToken?> {
        return .just(hasAccessToken ? dummyAccessToken: nil)
    }
    
    private let dummyAccessToken = "I'm dummy token."
}

