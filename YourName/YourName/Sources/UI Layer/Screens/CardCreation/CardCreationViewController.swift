//
//  CreateCardViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import RxGesture
import RxOptional
import RxSwift
import UIKit

final class CardCreationViewController: ViewController, Storyboarded {
    
    var viewModel: CardCreationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: CardCreationViewModel) {
        nameField?.rx.text
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typeName($0) })
            .disposed(by: disposeBag)
        
        roleField?.rx.text
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typeRole($0) })
            .disposed(by: disposeBag)
        
        personalityTitleField?.rx.text
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typePersonalityTitle($0) })
            .disposed(by: disposeBag)
        
        personalityKeywordField?.rx.text
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typePersonalityKeyword($0) })
            .disposed(by: disposeBag)
        
        aboutMeTextView?.rx.text
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typeAboutMe($0) })
            .disposed(by: disposeBag)
        
        completeButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapCompletion()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func render(_ viewModel: CardCreationViewModel) {
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
            viewModel.shouldHideClear
                .bind(to: profileClearButton.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
        if let profilePlaceholderView = self.profilePlaceholderView {
            viewModel.shouldHideProfilePlaceholder
                .bind(to: profilePlaceholderView.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] navigation in
                let viewController = UIViewController()
                self?.navigate(viewController, action: navigation.action)
            })
            .disposed(by: disposeBag)
        
        self.view.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { _ in self.view.endEditing(true) })
            .disposed(by: disposeBag)
        
    }
    
    private let disposeBag = DisposeBag()
    private let keyboard: Keyboard = KeyboardImpl.shared
    
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var profileClearButton: UIButton?
    @IBOutlet private weak var profilePlaceholderView: UIView?
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

enum ContactType: Int, CaseIterable {
    case phone
    case email
    case sns
}

struct ContactInfo {
    let type: ContactType
    let value: String
}

final class ContactInputView: UIView {
    @IBOutlet private weak var contactTypeView: UIView?
    @IBOutlet private weak var contactValueField: UITextField?
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
