//
//  ServiceNetwork.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation
import RxSwift
import Moya

protocol NetworkServing {
    func request<API>(_ api: API) -> Observable<API.Response> where API: ServiceAPI
}

final class NetworkService: NetworkServing {
    
    func request<API>(_ api: API) -> Observable<API.Response> where API : ServiceAPI {
        let endpoint = MultiTarget.target(api)
        
        return self.provider.rx.request(endpoint)
            .asObservable()
            .map(MeetuResponse<API.Response>.self)
            .map { $0.data }
            .filterNil()
    }
    
    private let provider = MoyaProvider<MultiTarget>()
    
}


