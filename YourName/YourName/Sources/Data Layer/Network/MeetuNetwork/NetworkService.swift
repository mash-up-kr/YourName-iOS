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
    
    var headers: [String: String] {
        guard let accessToken = self.accessToken else { return [:] }
        
        return ["authorization": "Bearer \(accessToken)"]
    }
    
    weak var authenticationRepository: AuthenticationRepository?
    
    func request<API>(_ api: API) -> Observable<API.Response> where API : ServiceAPI {
        return self._request(api)
            .catchError { [weak self] error -> Observable<MeetuResponse<API.Response>> in
                guard let self = self else { throw error }
                
                return self.refreshAuthentication()
                    .do { [weak self] authentication in
                        guard let self = self else { return }
                        guard let accessToken = authentication.accessToken else { return }
                        let authentication = Authentication(accessToken: accessToken,
                                                            refreshToken: self.refreshToken,
                                                            user: nil,
                                                            userOnboarding: nil)
                        self.accessToken = accessToken
                        self.authenticationRepository?.write(authentication: authentication)
                            .subscribe(onNext: { })
                            .disposed(by: self.disposeBag)
                    }.flatMap { [weak self] _ -> Observable<MeetuResponse<API.Response>> in
                        guard let self = self else { return .empty() }
                        return self._request(api)
                    }
                    .catchError { [weak self] error in
                        self?.refreshToken = nil
                        print("🐛 - ", error.localizedDescription)
                        return .error(error)
                    }
            }
            .compactMap { $0.data }
    }
    
    private func _request<API>(_ api: API) -> Observable<MeetuResponse<API.Response>> where API : ServiceAPI {
        let endpoint = MultiTarget.target(api)
        
        return self.provider.rx.request(endpoint)
            .asObservable()
            .map(MeetuResponse<API.Response>.self)
            .map { response -> MeetuResponse<API.Response> in
                guard let statusCode = response.statusCode else { throw NetworkError.unknown(-1, response.message) }
                guard statusCode != 401                    else { throw NetworkError.accessTokenInvalidate }
                guard statusCode < 400                     else { throw NetworkError.unknown(statusCode, response.message) }
                
                return response
            }
    }
    
    private func refreshAuthentication() -> Observable<Authentication> {
        guard let refreshToken = self.refreshToken else { return .error(NetworkError.hasNotRefreshToken) }
        
        let refreshAPI = RefreshAuthenticationAPI(refreshToken: refreshToken)
        return self._request(refreshAPI).compactMap { response -> Authentication? in
            guard response.statusCode != 401 else { throw NetworkError.denyAuthentication }
            return response.data
        }
    }
    
    private var accessToken: String? = Secret.dummyAccessToken
    private var refreshToken: String? = Secret.dummyRefreshToken
    
    private let disposeBag = DisposeBag()
    
    private let provider = MoyaProvider<MultiTarget>()
}

private extension Secret {
    
    static let dummyAccessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsIm5pY2tOYW1lIjoi7J207Jew7KSRIiwiaWF0IjoxNjM3ODM5MjQxLCJleHAiOjE2Mzg0MzkyNDF9.629okopRQ14ek0oX-2-phAJ03nfZEEpKCKWRjxiv9yA"
    
    static let dummyRefreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjExLCJ1c2VySWRlbnRpZmllciI6IjIwMDg1OTY5NjciLCJpYXQiOjE2MzgyMDAzNjEsImV4cCI6MTY0MDc5MjM2MX0.HqdUBL_9y5wZY3g0AmXJuX4jRPIa4Q6lDMHba2ixWho"
}


enum NetworkError: Error {
    case hasNotRefreshToken
    case accessTokenInvalidate
    case denyAuthentication
    case unknown(_ code: Int, _ message: String?)
}


