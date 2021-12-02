//
//  AuthenticationDelegate.swift
//  YourName
//
//  Created by Booung on 2021/09/20.
//

import Foundation

protocol AuthenticationDelegate {
    func signIn(accessToken: Secret, refreshToken: Secret)
    func notSignIn()
}
