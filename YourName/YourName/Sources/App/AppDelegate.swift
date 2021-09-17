//
//  AppDelegate.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let signedInContainer: SignedInContainer = SignedInContainer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let homeViewController = signedInContainer.homeViewController()
        let window = UIWindow()
        window.rootViewController = homeViewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
