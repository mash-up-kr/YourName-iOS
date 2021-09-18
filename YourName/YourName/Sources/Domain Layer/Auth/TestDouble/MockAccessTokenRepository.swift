//
//  MockAuth.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

final class MockAccessTokenRepository: AccessTokenRepository {
    
    var stubedAccessToken: AccessToken?
    
    func accessToken() -> Observable<AccessToken> {
        return .just(stubedAccessToken!)
    }
}
