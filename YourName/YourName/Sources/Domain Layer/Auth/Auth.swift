//
//  Auth.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import Foundation
import RxSwift

protocol OAuth {
    func authorize() -> Single<OAuthResponse>
}
