//
//  UIVIewController+.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import UIKit

extension UIViewController {
    static var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    static func visableViewController(_ viewController: UIViewController? = UIViewController.rootViewController) -> UIViewController? {
        if let tabBarController = viewController as? UITabBarController {
            return visableViewController(tabBarController.selectedViewController)
        } else if let naviController = viewController as? UINavigationController {
            return visableViewController(naviController.visibleViewController)
        } else if let presentedController = viewController?.presentedViewController {
            return visableViewController(presentedController)
        }
        return viewController
    }
}
extension UIViewController {
    func navigate(_ viewController: UIViewController, action: NavigationAction) {
        switch action {
        case .present:
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: { [weak self] in
                    viewController.modalPresentationStyle = .fullScreen
                    self?.present(viewController, animated: true, completion: nil)
                })
            } else {
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
            
        case .push:
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: { [weak self] in
                    self?.navigationController?.pushViewController(viewController, animated: true)
                })
            } else {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
