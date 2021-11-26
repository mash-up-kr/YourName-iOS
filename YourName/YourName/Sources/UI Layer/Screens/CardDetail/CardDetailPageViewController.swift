//
//  CardDetailPageViewController.swift
//  YourName
//
//  Created by KimKyungHoon on 2021/10/08.
//

import UIKit

class CardDetailPageViewController: UIViewController {
    
    // MARK: - Property
    var pageView: PageView {
        guard let mainView = self.view as? PageView else {
            fatalError()
        }
        return mainView
    }
    
    // MARK: - View Life Cycle
    override func loadView() {
        let view = PageView()
        view.backgroundColor = .black
        self.view = view
        view.pageViewController.setViewControllers([CardDetailFrontViewController()], direction: .forward, animated: false)
        view.pageViewController.dataSource = self
        view.pageViewController.delegate = self
        self.addChild(view.pageViewController)
        view.pageViewController.didMove(toParent: self)
        
    }
}

// MARK: - Extension
extension CardDetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController as? CardDetailFrontViewController != nil {
            return nil
        }
        
        return CardDetailFrontViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController as? CardDetailBackViewController != nil {
            return nil
        }
        
        return CardDetailBackViewController()
    }
}

extension CardDetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.pageView.finishAnimation()
        }
    }
}

