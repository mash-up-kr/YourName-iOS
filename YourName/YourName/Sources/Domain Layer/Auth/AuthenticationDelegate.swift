//
//  AuthenticationDelegate.swift
//  YourName
//
//  Created by Booung on 2021/09/20.
//

import Foundation

protocol AuthenticationDelegate {
    func signIn(withAccessToken accessToken: Secret)
    func notSignIn()
}
