//
//  AuthRepository.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation
import RxSwift

struct AuthenticationOption: OptionSet {
    let rawValue: Int
    
    static let accessToken =  AuthenticationOption(rawValue: 1 << 0)
    static let refreshToken = AuthenticationOption(rawValue: 1 << 1)
}

protocol AuthenticationRepository: AnyObject {
    func fetch(option: AuthenticationOption) -> Observable<Authentication?>
    func fetch(withProviderToken providerToken: Secret, provider: Provider) -> Observable<Authentication>
    func write(authentication: Authentication) -> Observable<Void>
    func remove(option: AuthenticationOption) -> Observable<Void>
    
    func logout() -> Observable<Void>
    func resign() -> Observable<Void>
}

final class YourNameAuthenticationRepository: AuthenticationRepository {
    
    init(localStorage: LocalStorage, network: NetworkServing) {
        self.localStorage = localStorage
        self.network = network
    }
    
    func fetch(option: AuthenticationOption = [.accessToken, .refreshToken]) -> Observable<Authentication?> {
        var screams: [Observable<Secret?>] = []
        
        if option.contains(.accessToken)  { screams.append(self.localStorage.read(.accessToken)) }
        if option.contains(.refreshToken) { screams.append(self.localStorage.read(.refreshToken)) }
        
        return Observable.zip(screams).map { authentication -> Authentication? in
                let accessToken = authentication[safe: 0] ?? nil
                let refreshToken = authentication[safe: 1] ?? nil
                return Authentication(accessToken: accessToken, refreshToken: refreshToken, user: nil, userOnboarding: nil)
            }
    }
    
    func fetch(withProviderToken providerToken: Secret, provider: Provider) -> Observable<Authentication> {
        return network.request(LoginAPI(accessToken: providerToken, provider: provider))
            .map { [weak self] authentication -> Authentication in
                if let accessToken = authentication.accessToken     { self?.save(accessToken: accessToken)   }
                if let refreshToken = authentication.refreshToken   { self?.save(refreshToken: refreshToken) }
                
                return authentication
            }
    }
    
    func write(authentication: Authentication) -> Observable<Void> {
        var screams: [Observable<Bool>] = []
        if let accessToken = authentication.accessToken   { screams.append(self.localStorage.write(.accessToken, value: accessToken))   }
        if let refreshToken = authentication.refreshToken { screams.append(self.localStorage.write(.refreshToken, value: refreshToken)) }
        
        return Observable.zip(screams).map { _ in Void() }
    }
    
    func remove(option: AuthenticationOption) -> Observable<Void> {
        var screams: [Observable<Bool>] = []
        if option.contains(.accessToken)  { screams.append(self.localStorage.delete(.accessToken))  }
        if option.contains(.refreshToken) { screams.append(self.localStorage.delete(.refreshToken)) }
        
        return Observable.zip(screams).map { _ in Void() }
    }
    
    func logout() -> Observable<Void> {
        return Environment.current.network.request(LogoutAPI())
                    .mapToVoid()
    }
    
    func resign() -> Observable<Void> {
        return Environment.current.network.request(ResignAPI())
                    .mapToVoid()
    }
    
    private func save(accessToken: String)  {
        self.localStorage.write(.accessToken, value: accessToken)
            .subscribe { print("access token save success \($0)") }
            .disposed(by: self.disposeBag)
    }
    
    private func save(refreshToken: String) {
        self.localStorage.write(.refreshToken, value: refreshToken)
            .subscribe { print("refresh token save success \($0)") }
            .disposed(by: self.disposeBag)
    }
    
    private let accessToken: String? = nil
    private let refreshToken: String? = nil
    
    private let network: NetworkServing
    private let localStorage: LocalStorage
    
    private let disposeBag = DisposeBag()
}
