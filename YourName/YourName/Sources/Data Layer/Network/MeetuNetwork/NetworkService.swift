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
        print("access Token 👉 \(accessToken)")
        return ["authorization": "Bearer \(accessToken)"]
    }
    
    weak var authenticationRepository: AuthenticationRepository?
    
    func request<API>(_ api: API) -> Observable<API.Response> where API : ServiceAPI {
        return self._request(api)
            .catchError { [weak self] error -> Observable<MeetuResponse<API.Response>> in
                guard let self = self else { throw error }
                if let meetUError = error as? NetworkError {
                    if meetUError == .accessTokenInvalidate {
                        print("💬 access token 만료시 에러처리")
                        return self.refreshAuthentication()
                            .do { [weak self] authentication in
                                guard let self = self else { return }
                                print("💬 기존 accesstoken", self.accessToken)
                    
                                guard let accessToken = authentication.accessToken else { return }
                                let authentication = Authentication(accessToken: accessToken,
                                                                    refreshToken: self.refreshToken,
                                                                    user: nil,
                                                                    userOnboarding: nil)
                                self.accessToken = accessToken
                                print("💬 바꾼 accesstoken", accessToken)
                                print("💬 바꾼 authentication", authentication)
                                self.authenticationRepository?.write(authentication: authentication)
                                    .debug("💬 authentication write")
                                    .subscribe(onNext: { _ in
                                        print("💬 user defaults에 저장완료", accessToken)
                                    })
                                    .disposed(by: self.disposeBag)
                            }
                            .flatMap { [weak self] _ -> Observable<MeetuResponse<API.Response>> in
                                guard let self = self else { return .empty() }
                                return self._request(api)
                            }
                            .catchError { [weak self] error in
                                // refresh token까지 만료된 상황 -> 로그아웃시킨다
                                print("💬 refresh까지 만료되어버렸다......")
                                return Observable.zip(UserDefaults.standard.delete(.accessToken),
                                                      UserDefaults.standard.delete(.refreshToken))
                                    .flatMap { [weak self] _ -> Observable<MeetuResponse<API.Response>>in
                                        print("💬 로그아웃을 시킨다.")
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
                print(statusCode, "💬 status code")
                guard statusCode != 401                    else { throw NetworkError.accessTokenInvalidate }
                guard statusCode < 400                     else { throw NetworkError.unknown(statusCode, response.message) }
                return response
            }
    }
    
    private func refreshAuthentication() -> Observable<Authentication> {
        guard let refreshToken = self.refreshToken else { return .error(NetworkError.hasNotRefreshToken) }
        print("access가 만료되어서 refresh로 access다시 시도💬 중")
        let refreshAPI = RefreshAuthenticationAPI(refreshToken: refreshToken)
        return self._request(refreshAPI).compactMap { response -> Authentication? in
            print("access가 만료되어서 refresh로 access다시 시도💬",response)
            guard response.statusCode != 401 else { throw NetworkError.denyAuthentication }
            return response.data
        }
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit ")
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


