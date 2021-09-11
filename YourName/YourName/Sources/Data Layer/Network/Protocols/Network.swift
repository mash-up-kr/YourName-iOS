//
//  Network.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import Foundation
import RxSwift

protocol Network {
    func response<Api: API>(of api: Api) -> Observable<Api.Response>
}
