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
    
    var headers: [String: String] = ["authorization": "Bearer \(AccessToken.dummyAccessToken)"]
    
    func request<API>(_ api: API) -> Observable<API.Response> where API : ServiceAPI {
        return self._request(api)
            .catchError { [weak self] error -> Observable<MeetuResponse<API.Response>> in
                guard let self = self else { throw error }
                
                return self.refreshAuthentication()
                    .do { authentication in
                        guard let accessToken = authentication.accessToken else { return }
                        self.headers = ["authorization" : "Bearer \(accessToken)"]
                    }.flatMap { [weak self] _ -> Observable<MeetuResponse<API.Response>> in
                        guard let self = self else { return .empty() }
                        return self._request(api)
                    }
                    .catchError { [weak self] _ in
                        self?.refreshToken = nil
                        return .error(NetworkError.denyAuthentication)
                    }
            }
            .compactMap { $0.data }
    }
    
    private func _request<API>(_ api: API) -> Observable<MeetuResponse<API.Response>> where API : ServiceAPI {
        let endpoint = MultiTarget.target(api)
        
        return self.provider.rx.request(endpoint)
            .asObservable()
            .map(MeetuResponse<API.Response>.self)
            .do { response in
                guard let statusCode = response.statusCode else { throw NetworkError.unknown }
                if statusCode == 401 { throw NetworkError.accessTokenInvalidate }
                else if statusCode > 400 { throw NetworkError.unknown }
            }
    }
    
    private func refreshAuthentication() -> Observable<Authentication> {
        guard let refreshToken = self.refreshToken else { return .error(NetworkError.hasNotRefreshToken) }
        
        let refreshAPI = RefreshAuthenticationAPI(refreshToken: refreshToken)
        return self._request(refreshAPI).compactMap { response -> Authentication? in
            if response.statusCode == 401 { throw NetworkError.denyAuthentication }
            return response.data
        }
    }
    
    private let provider = MoyaProvider<MultiTarget>()
    private var refreshToken: String? = AccessToken.dummyRefreshDummy
    
}

private extension AccessToken {
    static let dummyAccessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsIm5pY2tOYW1lIjoi7J207Jew7KSRIiwiaWF0IjoxNjM3ODM5MjQxLCJleHAiOjE2Mzg0MzkyNDF9.629okopRQ14ek0oX-2-phAJ03nfZEEpKCKWRjxiv9yA"
}
private extension AccessToken {
    static let dummyRefreshDummy = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjExLCJ1c2VySWRlbnRpZmllciI6IjIwMDg1OTY5NjciLCJpYXQiOjE2MzgyMDAzNjEsImV4cCI6MTY0MDc5MjM2MX0.HqdUBL_9y5wZY3g0AmXJuX4jRPIa4Q6lDMHba2ixWho"
}

typealias Authentication = Entity.Authentication

enum NetworkError: Error {
    case hasNotRefreshToken
    case accessTokenInvalidate
    case denyAuthentication
    case unknown
}
