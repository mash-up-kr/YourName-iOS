//
//  CardDetailViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit
import RxSwift
import RxCocoa

typealias cardID = String
final class CardDetailViewController: ViewController, Storyboarded {
    
    var cardDetailMoreViewFactory: ((cardID) -> CardDetailMoreViewController)!
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var detailMoreButton: UIButton!
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
            self.underlineViewCenterX.isActive = false
            self.underlineViewCenterX = nil
            self.underlineViewCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.frontButton.centerXAnchor)
            self.underlineViewCenterX.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction private func backButtonClick(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.underlineViewCenterX.isActive = false
            self.underlineViewCenterX = nil
            self.underlineViewCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.backButton.centerXAnchor)
            self.underlineViewCenterX.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.render(self.viewModel)
        self.dispatch(to: self.viewModel)
        
        initPageViewController()
        bubbleBottom.transform = CGAffineTransform(rotationAngle: 45/360 * Double.pi)
    }
    
    @IBOutlet private weak var underlineViewCenterX: NSLayoutConstraint!
    
    var viewModel: CardDetailViewModel!
    
    @IBOutlet private weak var mainView: UIView!
    private func initPageViewController() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        
        print(mainView.frame)
        print(pageViewController.view.frame)
        // front 배열 추가
        
        let viewControllers:[UIViewController] = Array(0...0).map { _ in UIViewController() }
//        [CardDetailBackViewController]()
        pageViewController.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: nil)
        
        self.addChild(pageViewController)
        mainView.addSubview(pageViewController.view)
        pageViewController.view.frame = mainView.bounds
        pageViewController.didMove(toParent: self)
    }
}


extension CardDetailViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("before")

        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // 만든거 호출로 구현
        
        if viewController as? CardDetailBackViewController != nil {
            return nil
        }

        return nil
    }
}

extension CardDetailViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?[safe:0] as? CardDetailFrontViewController {
//                pageControl.currentPage = currentViewController.index
            } else if let currentViewController = pageViewController.viewControllers?[safe:0] as? CardDetailBackViewController {
//                pageControl.currentPage = currentViewController.index
            }
        }
    }
}
class CardDetailFrontViewController: UIViewController {}


extension CardDetailViewController {
    private func bind() {
        self.detailMoreButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.viewModel.didTapMore()
            })
            .disposed(by: disposeBag)
    }
    
    private func render(_ viewModel: CardDetailViewModel) {
        
    }
    
    private func dispatch(to viewModel: CardDetailViewModel) {
        self.rx.viewDidAppear
            .flatMapFirst { [weak self] _ -> Observable<CardDetailNavigation> in
                guard let self = self else { return .empty() }
                return self.viewModel.navigation.asObservable()
            }
            .bind(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigate(_ navigation: CardDetailNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: CardDetailDestination) -> UIViewController {
        switch next {
        case .cardDetailMore(let cardId):
            return cardDetailMoreViewFactory(cardId)
        }
    }
}
