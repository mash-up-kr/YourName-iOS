//
//  CreateCardViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import Kingfisher
import RxGesture
import RxOptional
import RxSwift
import UIKit

final class CardCreationViewController: ViewController, Storyboarded {
    
    var viewModel: CardCreationViewModel!
    var characterCreationViewControllerFactory: (() -> CharacterCreationViewController)?
    var paletteViewControllerFactory: (() -> PaletteViewController)?
    var tmiSettingViewControllerFactory: (() -> TMISettingViewController)?
    var skillSettingViewControllerFactory: (() -> SkillSettingViewController)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundSettingButton?.clipsToBounds = true
        profileBackgroundColorButtonLayer.frame = backgroundSettingButton?.bounds ?? .zero
        backgroundSettingButton?.layer.insertSublayer(profileBackgroundColorButtonLayer, at: 0)
        profileBackgroundColorButtonLayer.startPoint = .zero
        profileBackgroundColorButtonLayer.endPoint = CGPoint(x: 1, y: 1)
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
    }
    
    private func dispatch(to viewModel: CardCreationViewModel) {
        
        profileClearButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapProfileClear() })
            .disposed(by: disposeBag)
        
        profilePlaceholderView?.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in self?.viewModel.tapProfilePlaceHolder() })
            .disposed(by: disposeBag)
        
        backgroundSettingButton?.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.viewModel.tapProfileBackgroundSetting() })
            .disposed(by: disposeBag)
        
        nameField?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typeName($0) })
            .disposed(by: disposeBag)
        
        roleField?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typeRole($0) })
            .disposed(by: disposeBag)
        
        mySkillSettingButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapSkillSetting() })
            .disposed(by: disposeBag)
        
        contactInputViews?.enumerated().forEach { index, contactInputView in
            contactInputView.rx.contactType.distinctUntilChanged()
                .subscribe(onNext: { [weak self] in self?.viewModel.selectContactType($0, index: index) })
                .disposed(by: disposeBag)
            
            contactInputView.rx.contactValue.distinctUntilChanged()
                .subscribe(onNext: { [weak self] in self?.viewModel.typeContactValue($0, index: index) })
                .disposed(by: disposeBag)
        }
        
        personalityTitleField?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typePersonalityTitle($0) })
            .disposed(by: disposeBag)
        
        personalityKeywordField?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typePersonalityKeyword($0) })
            .disposed(by: disposeBag)
        
        myTMISettingButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapTMISetting() })
            .disposed(by: disposeBag)
        
        aboutMeTextView?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typeAboutMe($0) })
            .disposed(by: disposeBag)
        
        completeButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapCompletion()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        self.view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in self.view.endEditing(true) })
            .disposed(by: disposeBag)
    }
    
    private func render(_ viewModel: CardCreationViewModel) {
        
        if let profilePlaceholderView = self.profilePlaceholderView {
            viewModel.shouldHideProfilePlaceholder.distinctUntilChanged()
                .bind(to: profilePlaceholderView.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
        if let profileImageView = self.profileImageView {
        viewModel.profileImageSource.distinctUntilChanged()
            .bind(to: profileImageView.rx.imageSource)
            .disposed(by: disposeBag)
        }
        
        viewModel.profileBackgroundColor.distinctUntilChanged()
            .subscribe(onNext: { [weak self] backgroundColor in
                switch backgroundColor {
                case .monotone(let color):
                    self?.backgroundSettingButton?.backgroundColor = color
                    self?.profileBackgroundColorButtonLayer.colors = nil
                case .gradient(let colors):
                    self?.backgroundSettingButton?.backgroundColor = nil
                    self?.profileBackgroundColorButtonLayer.colors = colors.map(\.cgColor)
                }
            })
            .disposed(by: disposeBag)
        
        if let nameField = self.nameField {
            viewModel.name.distinctUntilChanged()
                .bind(to: nameField.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let roleField = self.roleField {
            viewModel.role.distinctUntilChanged()
                .bind(to: roleField.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let personalityTitleField = self.personalityTitleField {
            viewModel.personalityTitle.distinctUntilChanged()
                .bind(to: personalityTitleField.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let personalityKeywordField = self.personalityKeywordField {
            viewModel.personalityKeyword.distinctUntilChanged()
                .bind(to: personalityKeywordField.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let aboutMeTextView = self.aboutMeTextView {
            viewModel.aboutMe.distinctUntilChanged()
                .bind(to: aboutMeTextView.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let profileClearButton = self.profileClearButton {
            viewModel.shouldHideClear.distinctUntilChanged()
                .bind(to: profileClearButton.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
        if let aboutMePlaceholderLabel = self.aboutMePlaceholderLabel {
            viewModel.aboutMe.map { $0.isEmpty == false }
                .distinctUntilChanged()
                .bind(to: aboutMePlaceholderLabel.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
//        viewModel.navigation
//            .subscribe(onNext: { [weak self] navigation in
//                let viewController = UIViewController()
//                self?.navigate(viewController, action: navigation.action)
//            })
//            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let keyboard: Keyboard = KeyboardImpl.shared
    private let profileBackgroundColorButtonLayer = CAGradientLayer()
    
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var profileClearButton: UIButton?
    @IBOutlet private weak var profilePlaceholderView: UIView?
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var backgroundSettingButton: UIButton?
    @IBOutlet private weak var nameField: UITextField?
    @IBOutlet private weak var roleField: UITextField?
    @IBOutlet private weak var mySkillSettingButton: UIButton?
    @IBOutlet private var contactInputViews: [ContactInputView]?
    @IBOutlet private weak var personalityTitleField: UITextField?
    @IBOutlet private weak var personalityKeywordField: UITextField?
    @IBOutlet private weak var myTMISettingButton: UIButton?
    @IBOutlet private weak var aboutMeTextView: UITextView?
    @IBOutlet private weak var aboutMePlaceholderLabel: UILabel?
    @IBOutlet private weak var keyboardFrameViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var completeButton: UIButton?
}


import RxRelay

protocol Keyboard {
    var isHidden: BehaviorRelay<Bool> { get }
    var height: BehaviorRelay<CGFloat> { get }
    var animationDuration: BehaviorRelay<TimeInterval> { get }
}

final class KeyboardImpl: NSObject, Keyboard {
    static let shared = KeyboardImpl()
    
    let isHidden = BehaviorRelay(value: false)
    let height = BehaviorRelay<CGFloat>(value: .zero)
    let animationDuration = BehaviorRelay(value: 0.25)
    
    override init() {
        super.init()
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 336
                let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
                self?.height.accept(keyboardHeight)
                self?.animationDuration.accept(duration)
                self?.isHidden.accept(false)
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: {  [weak self] notification in
                let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 336
                let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
                self?.height.accept(keyboardHeight)
                self?.animationDuration.accept(duration)
                self?.isHidden.accept(true)
            }).disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
}
