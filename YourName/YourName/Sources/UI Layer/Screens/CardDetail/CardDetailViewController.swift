////
////  CardDetailViewController.swift
////  YourName
////
////  Created by Booung on 2021/09/21.
////
//
//import UIKit
//import Toast_Swift
//import RxSwift
//import RxCocoa
//
//final class CardDetailViewController: ViewController, Storyboarded {
//
////    var cardEditViewFactory: ((Identifier) -> CardCreationViewController)!
//    var cardDetailMoreViewFactory: ((Identifier) -> CardDetailMoreViewController)!
//    private let disposeBag = DisposeBag()
//
//    @IBOutlet private weak var detailMoreButton: UIButton!
//    @IBOutlet weak var bubbleBottom: UIView!
//    @IBOutlet private weak var underlineView: UIView!
//    @IBOutlet private weak var frontButton: UIButton!
//    @IBOutlet private weak var backButton: UIButton!
//    @IBOutlet weak var speechBubble: UIView!
//    @IBAction func settingButton(_ sender: Any) {
//        //붙여야 되는 부분
//
//    }
//
//    @IBOutlet weak var mySkillProgressView1: MySkillProgressView!
//    @IBOutlet weak var mySkillProgressView2: MySkillProgressView!
//    @IBOutlet weak var mySkillProgressView3: MySkillProgressView!
//
//    @IBOutlet weak var cardDetailFrontView: UIStackView!
//
//    @IBOutlet weak var cardDetailBackView: UIStackView!
//
//    override var hidesBottomBarWhenPushed: Bool {
//        get {
//            return navigationController?.topViewController == self
//        } set {
//            super.hidesBottomBarWhenPushed = newValue
//        }
//    }
//
//    @IBAction private func frontButtonClick(_ sender: Any) {
//        UIView.animate(withDuration: 0.2) {
//
//            self.underlineCenterX?.isActive = false
//            self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.frontButton.centerXAnchor)
//            self.underlineCenterX?.isActive = true
//            self.view.layoutIfNeeded()
//        }
//    }
//
//    var underlineCenterX: NSLayoutConstraint?
//
//    @IBAction private func backButtonClick(_ sender: Any) {
//        UIView.animate(withDuration: 0.2) {
//
//            self.underlineCenterX?.isActive = false
//            self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.backButton.centerXAnchor)
//            self.underlineCenterX?.isActive = true
//            self.view.layoutIfNeeded()
//        }
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.underlineCenterX?.isActive = false
//        self.underlineCenterX = self.underlineView.centerXAnchor.constraint(equalTo: self.frontButton.centerXAnchor)
//        self.underlineCenterX?.isActive = true
//
//        self.bind()
//        self.render(self.viewModel)
//        self.dispatch(to: self.viewModel)
//
//        bubbleBottom.transform = CGAffineTransform(rotationAngle: 45/360 * Double.pi)
//        addGesture()
//    }
//
//
//    func addGesture() {
//        speechBubble.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGetstureDetected))
//
//         speechBubble.addGestureRecognizer(tapGesture)
//
//     }
//
//    @objc func tapGetstureDetected() {
//        print("Touch/Tap Gesture detected!!")
//        self.navigationController?.view.showToast(ToastView(text: "코드명이 복사되었츄!"), position: .top)
//    }
//
//    var viewModel: CardDetailViewModel!
//
////    @IBOutlet private weak var mainView: UIView!
////    @IBOutlet private weak var bubbleBottom: UIView!
////    @IBOutlet private weak var underlineView: UIView!
////    @IBOutlet private weak var frontButton: UIButton!
////    @IBOutlet private weak var backButton: UIButton!
////    @IBOutlet private weak var cardDetailFrontView: UIStackView!
////    @IBOutlet private weak var speechBubble: UIView!
////    @IBOutlet private weak var mySkillProgressView1: MySkillProgressView!
////    @IBOutlet private weak var mySkillProgressView2: MySkillProgressView!
////    @IBOutlet private weak var mySkillProgressView3: MySkillProgressView!
////    @IBOutlet private weak var cardDetailBackView: UIStackView!
//
//}
//
//
//
//extension CardDetailViewController {
//    private func bind() {
//        self.detailMoreButton.rx.throttleTap
//            .bind(onNext: { [weak self] in
//                self?.viewModel.didTapMore()
//            })
//            .disposed(by: disposeBag)
//    }
//
//    private func render(_ viewModel: CardDetailViewModel) {
//        viewModel.navigationPop
//            .bind(onNext: { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        viewModel.alertController
//            .bind(onNext: { [weak self] in
//                self?.present($0, animated: true)
//            })
//            .disposed(by: self.disposeBag)
//
//        viewModel.isLoading
//            .distinctUntilChanged()
//            .bind(to: self.isLoading)
//            .disposed(by: self.disposeBag)
//    }
//
//    private func dispatch(to viewModel: CardDetailViewModel) {
//        self.rx.viewDidAppear
//            .flatMapFirst { [weak self] _ -> Observable<CardDetailNavigation> in
//                guard let self = self else { return .empty() }
//                return self.viewModel.navigation.asObservable()
//            }
//            .bind(onNext: { [weak self] action in
//                guard let self = self else { return }
//                self.navigate(action)
//            })
//            .disposed(by: disposeBag)
//    }
//
//    private func navigate(_ navigation: CardDetailNavigation) {
//        let viewController = createViewController(navigation.destination)
//        navigate(viewController, action: navigation.action)
//    }
//
//    private func createViewController(_ next: CardDetailDestination) -> UIViewController {
//        switch next {
//        case .cardDetailMore(let cardId):
//            return cardDetailMoreViewFactory(cardId)
//        case .cardEdit(let cardId):
//            return cardDetailMoreViewFactory(cardId)
////            return cardEditViewFactory(cardId)
//        }
//    }
//}
