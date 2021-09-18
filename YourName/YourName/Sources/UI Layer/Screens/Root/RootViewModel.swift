//
//  RootViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation
import RxSwift

enum RootPath {
    case signedOut
    case signedIn
}

typealias RootNavigation = Navigation<RootPath>

struct RootViewModel {
    let navigation = PublishSubject<RootNavigation>()
}
