//
//  PageView.swift
//  YourName
//
//  Created by KimKyungHoon on 2021/10/09.
//

import UIKit

class PageView: UIView {
 
 
    let detailViewController = CardDetailViewController()
    
    
    enum SelectedType {
            case firstView
            case secondView
        }
        
        let pageViewController: UIPageViewController = {
             let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
             return pageViewController
         }()
    
    // MARK: - Func
       func getCurrentViewControllerType() -> SelectedType? {
           let currentVC = self.pageViewController.viewControllers?.first
           return currentVC is CardDetailFrontViewController ? .firstView : .secondView
       }
       
       func makeButtonStatus(_ target: UIButton?, isSelected: Bool) {
           guard let target = target else { return }
           let type = isSelected ? "Bold" : "Regular"
           let titleColor: UIColor = isSelected ? .black : .gray
           
           target.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-\(type)", size: 20)
           target.setTitleColor(titleColor, for: .normal)
       }
       
        func selectedLabel(_ selectedType: SelectedType) {
            let isFirstButton = selectedType == .firstView ? true : false
//            self.makeButtonStatus(detailViewController.frontButton, isSelected: isFirstButton)
//            self.makeButtonStatus(detailViewController.backButton, isSelected: !isFirstButton)
        }
        
        func finishAnimation() {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: {
                if self.pageViewController.viewControllers?[0] as? CardDetailFrontViewController != nil {
                    self.selectedLabel(.firstView)
                } else {
                    self.selectedLabel(.secondView)
                }
                self.layoutIfNeeded()
            })
        }
//    
//        @objc func touchButton(_ sender: UIButton) {
//            if sender == detailViewController.frontButton, getCurrentViewControllerType() != .firstView {
//                self.pageViewController.setViewControllers([CardDetailFrontViewController()], direction: .reverse, animated: true)
//            } else if sender == detailViewController.backButton, getCurrentViewControllerType() != .secondView {
//                self.pageViewController.setViewControllers([CardDetailBackViewController()], direction: .forward, animated: true)
//            }
//            finishAnimation()
//        }

    
    
}
