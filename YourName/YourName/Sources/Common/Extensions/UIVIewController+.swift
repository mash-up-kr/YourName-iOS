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
        case .present(let animated):
//            closeOverlayViewControllers(completion: { [weak self] in
//                viewController.modalPresentationStyle = .fullScreen
//                self?.present(viewController, animated: animated, completion: nil)
//            })
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: { [weak self] in
                    viewController.modalPresentationStyle = .fullScreen
                    self?.present(viewController, animated: animated, completion: nil)
                })
            } else {
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: animated, completion: nil)
            }
            
        case .push:
//            closeOverlayViewControllers(completion: { [weak self] in
//                viewController.modalPresentationStyle = .fullScreen
//                self?.navigationController?.pushViewController(viewController, animated: true)
//            })
                    if let presentedViewController = self.presentedViewController {
                        presentedViewController.dismiss(animated: false, completion: { [weak self] in
                            self?.navigationController?.pushViewController(viewController, animated: true)
                        })
                    } else {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
            
        case .show(let isDimmed):
            let underlaiedViewController = self
            let overlaiedViewController = viewController
            overlaiedViewController.modalPresentationStyle = .overFullScreen
            let completion: (() -> Void)?
            if isDimmed {
                let dimmedColor = Palette.black1.withAlphaComponent(0.6)
                let dimmedView = UIView().then {
                    $0.layer.shouldRasterize = true
                    $0.backgroundColor = Palette.black1.withAlphaComponent(0.6)
                    $0.frame = underlaiedViewController.view.bounds
                }
                overlaiedViewController.view.backgroundColor = .clear
                underlaiedViewController.view.addSubview(dimmedView)
                completion = { [weak dimmedView, weak overlaiedViewController] in
                    dimmedView?.removeFromSuperview()
                    overlaiedViewController?.view.backgroundColor = dimmedColor
                }
            } else {
                completion = nil
            }
//            closeOverlayViewControllers(completion: { [weak underlaiedViewController] in
//                underlaiedViewController?.present(overlaiedViewController, animated: true, completion: completion)
//            })
            if let presentedViewController = self.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: { [weak underlaiedViewController] in
                    underlaiedViewController?.present(overlaiedViewController, animated: true, completion: completion)
                })
            } else {
                underlaiedViewController.present(overlaiedViewController, animated: true, completion: completion)
            }

        }
    }
    
    func closeOverlayViewControllers(completion: @escaping () -> Void = {}) {
        let visableViewController = UIViewController.visableViewController()
        guard visableViewController === self else { return completion() }
        
        if let naviController = visableViewController?.navigationController {
            naviController.popViewController(animated: true)
            self.closeOverlayViewControllers(completion: completion)
        } else {
            visableViewController?.dismiss(animated: false, completion: { [weak self] in
                self?.closeOverlayViewControllers(completion: completion)
            })
        }
    }
}
