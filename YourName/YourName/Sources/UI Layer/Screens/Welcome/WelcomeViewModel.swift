//
//  SignInViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

struct WelcomeViewModel {
    
    init(delegate: AuthenticationDelegate) {
        self.delegate = delegate
    }
    
    func signIn(with provider: Provider) {
        #warning("⚠️ TODO: 리얼 로직 구현 필요함") // Booung
        delegate.signIn(withAccessToken: "Fake Access Token")
    }
    
    private let delegate: AuthenticationDelegate
}
