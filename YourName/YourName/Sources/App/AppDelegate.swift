//
//  AppDelegate.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import Firebase
import FLEX

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let rootDependencyContainer = RootDependencyContainer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = rootDependencyContainer.createRootViewController()
        let window = UIWindow()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        
        kakaoSDKInit()
        FirebaseApp.configure()
        FLEXManager.shared.showExplorer()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    private func kakaoSDKInit() {
        KakaoSDKCommon.initSDK(appKey: KakaoAppKey.nativeAppKey)
    }
}
