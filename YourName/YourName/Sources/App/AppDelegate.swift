//
//  AppDelegate.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let rootContainer: RootContainer = RootContainer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = rootContainer.rootViewController()
        let window = UIWindow()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}

