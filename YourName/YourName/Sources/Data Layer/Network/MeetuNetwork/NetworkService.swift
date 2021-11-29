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
    var headers: [String: String] { get }
    func request<API>(_ api: API) -> Observable<API.Response> where API: ServiceAPI
}

final class NetworkService: NetworkServing {
    
    var headers: [String: String] = ["authorization": "Bearer \(AccessToken.dummy)"]
    
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
private extension AccessToken {
    static let dummy = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsIm5pY2tOYW1lIjoi7J207Jew7KSRIiwiaWF0IjoxNjM3ODM5MjQxLCJleHAiOjE2Mzg0MzkyNDF9.629okopRQ14ek0oX-2-phAJ03nfZEEpKCKWRjxiv9yA"
    
}
