//
//  CardDetailViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit


final class CardDetailViewController: ViewController, Storyboarded {
    

    @IBOutlet weak var bubbleBottom: UIView!
    @IBOutlet private weak var underlineView: UIView!
    @IBOutlet private weak var frontButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBAction func settingButton(_ sender: Any) {
        //붙여야 되는 부분

    }

    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    @IBAction private func frontButtonClick(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            
            self.underlineCenterX?.isActive = false
            self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.frontButton.centerXAnchor)
            self.underlineCenterX?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    var underlineCenterX: NSLayoutConstraint?
    
    @IBAction private func backButtonClick(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            
            self.underlineCenterX?.isActive = false
            self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.backButton.centerXAnchor)
            self.underlineCenterX?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.underlineCenterX?.isActive = false
        self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.frontButton.centerXAnchor)
        self.underlineCenterX?.isActive = true
        initPageViewController()
        bubbleBottom.transform = CGAffineTransform(rotationAngle: 45/360 * Double.pi)
    }
    

    
    var viewModel: CardDetailViewModel!
    
    @IBOutlet private weak var mainView: UIView!
    private func initPageViewController() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

        
        pageViewController.dataSource = self
//        pageViewController.delegate = self
        
        
        let viewControllers:[UIViewController] = Array(0...0).map { _ in UIViewController() }
        
        if let firstVC = viewControllers.first {
                   pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
               }

        pageViewController.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: nil)
        
        self.addChild(pageViewController)
        mainView.addSubview(pageViewController.view)
        pageViewController.view.frame = mainView.bounds
        pageViewController.didMove(toParent: self)
    }
}


extension CardDetailViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let index = viewControllers?.firstIndex(of: ViewController) else { return nil }
//        let previousIndex = index - 1
//        if previousIndex < 0 {
//            return nil
//        }
//        return viewControllers[previousIndex]
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
//        guard let index = viewControllers?.firstIndex(of: ViewController) else { return nil }
//        let nextIndex = index + 1
//        if nextIndex == viewControllers.count {
//            return nil
//        }
//        return viewControllers[nextIndex]
        return nil
    }
}

//extension CardDetailViewController: UIPageViewControllerDelegate {
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed {
//            if let currentViewController = pageViewController.viewControllers?[safe:0] as? CardDetailFrontViewController {
////                pageControl.currentPage = currentViewController.index
//            } else if let currentViewController = pageViewController.viewControllers?[safe:0] as? CardDetailBackViewController {
////                pageControl.currentPage = currentViewController.index
//            }
//        }
//    }
//}
class CardDetailFrontViewController: UIViewController {}
