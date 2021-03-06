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
    func setupAuthentication(accessToken: Secret, refreshToken: Secret)
    func request<API>(_ api: API) -> Observable<API.Response> where API: ServiceAPI
}

final class NetworkService: NetworkServing {
    
    var headers: [String: String] {
        guard let accessToken = self.accessToken else { return [:] }
        print("access Token ๐ \(accessToken)")
        return ["authorization": "Bearer \(accessToken)"]
    }
    
    weak var authenticationRepository: AuthenticationRepository?
    
    func request<API>(_ api: API) -> Observable<API.Response> where API : ServiceAPI {
        return self._request(api)
            .catchError { [weak self] error -> Observable<MeetuResponse<API.Response>> in
                guard let self = self else { throw error }
                if let meetUError = error as? NetworkError {
                    if meetUError == .accessTokenInvalidate {
                        print("๐ฌ access token ๋ง๋ฃ์ ์๋ฌ์ฒ๋ฆฌ")
                        return self.refreshAuthentication()
                            .do { [weak self] authentication in
                                guard let self = self else { return }
                                print("๐ฌ ๊ธฐ์กด accesstoken", self.accessToken)
                    
                                guard let accessToken = authentication.accessToken else { return }
                                let authentication = Authentication(accessToken: accessToken,
                                                                    refreshToken: self.refreshToken,
                                                                    user: nil,
                                                                    userOnboarding: nil)
                                self.accessToken = accessToken
                                print("๐ฌ ๋ฐ๊พผ accesstoken", accessToken)
                                print("๐ฌ ๋ฐ๊พผ authentication", authentication)
                                self.authenticationRepository?.write(authentication: authentication)
                                    .debug("๐ฌ authentication write")
                                    .subscribe(onNext: { _ in
                                        print("๐ฌ user defaults์ ์?์ฅ์๋ฃ", accessToken)
                                    })
                                    .disposed(by: self.disposeBag)
                            }
                            .flatMap { [weak self] _ -> Observable<MeetuResponse<API.Response>> in
                                guard let self = self else { return .empty() }
                                return self._request(api)
                            }
                            .catchError { [weak self] error in
                                // refresh token๊น์ง ๋ง๋ฃ๋ ์ํฉ -> ๋ก๊ทธ์์์ํจ๋ค
                                print("๐ฌ refresh๊น์ง ๋ง๋ฃ๋์ด๋ฒ๋?ธ๋ค......")
                                return Observable.zip(UserDefaults.standard.delete(.accessToken),
                                                      UserDefaults.standard.delete(.refreshToken))
                                    .flatMap { [weak self] _ -> Observable<MeetuResponse<API.Response>>in
                                        print("๐ฌ ๋ก๊ทธ์์์ ์ํจ๋ค.")
                                        self?.accessToken = nil
                                        self?.refreshToken = nil
                                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                        appDelegate?.window?.rootViewController = RootDependencyContainer().createRootViewController()
                                        return .empty()
                                    }
                            }
                    } else { throw error }
                } else { throw error }
            }
            .compactMap { $0.data }
    }
    
    func setupAuthentication(accessToken: Secret, refreshToken: Secret) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    private func _request<API>(_ api: API) -> Observable<MeetuResponse<API.Response>> where API : ServiceAPI {
        let endpoint = MultiTarget.target(api)
        
        return self.provider.rx.request(endpoint)
            .asObservable()
            .map(MeetuResponse<API.Response>.self)
            .map { response -> MeetuResponse<API.Response> in
                guard let statusCode = response.statusCode else { throw NetworkError.unknown(-1, response.message) }
                print(statusCode, "๐ฌ status code")
                guard statusCode != 401                    else { throw NetworkError.accessTokenInvalidate }
                guard statusCode < 400                     else { throw NetworkError.unknown(statusCode, response.message) }
                return response
            }
    }
    
    private func refreshAuthentication() -> Observable<Authentication> {
        guard let refreshToken = self.refreshToken else { return .error(NetworkError.hasNotRefreshToken) }
        print("access๊ฐ ๋ง๋ฃ๋์ด์ refresh๋ก access๋ค์ ์๋๐ฌ ์ค")
        let refreshAPI = RefreshAuthenticationAPI(refreshToken: refreshToken)
        return self._request(refreshAPI).compactMap { response -> Authentication? in
            print("access๊ฐ ๋ง๋ฃ๋์ด์ refresh๋ก access๋ค์ ์๋๐ฌ",response)
            guard response.statusCode != 401 else { throw NetworkError.denyAuthentication }
            return response.data
        }
    }
    
    deinit {
        print(" ๐ \(String(describing: self)) deinit ")
    }
    
    private var accessToken: Secret?
    private var refreshToken: Secret?
    
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<MultiTarget>()
}

enum NetworkError: Error, Equatable {
    case hasNotRefreshToken
    case accessTokenInvalidate
    case denyAuthentication
    case unknown(_ code: Int, _ message: String?)
}


