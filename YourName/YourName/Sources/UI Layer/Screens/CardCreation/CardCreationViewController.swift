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
    var imageSourceTypePickerViewControllerFactory: (() -> ImageSourceTypePickerViewController)?
    var characterSettingViewControllerFactory: (() -> CharacterSettingViewController)?
    var paletteViewControllerFactory: (() -> PaletteViewController)?
    var tmiSettingViewControllerFactory: (() -> TMISettingViewController)?
    var skillSettingViewControllerFactory: (() -> SkillSettingViewController)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    private func setupUI() {
        contactTypePickerView?.dataSource = self
        contactTypePickerView?.delegate = self
    }
    
    private func dispatch(to viewModel: CardCreationViewModel) {
        viewModel.didLoad()
        
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
            
            contactInputView.rx.tapContactType
                .map { _ in index }
                .subscribe(onNext: { [weak self] index in
                    self?.viewModel.tapContactType(at: index)
                })
                .disposed(by: disposeBag)
            
            contactInputView.rx.contactValue
                .distinctUntilChanged()
                .subscribe(onNext: { [weak self] in
                    self?.viewModel.typeContactValue($0, index: index)
                })
                .disposed(by: disposeBag)
        }
        
        personalityTextView?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typePersonality($0) })
            .disposed(by: disposeBag)
        
        myTMISettingButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapTMISetting() })
            .disposed(by: disposeBag)
        
        aboutMeTextView?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] in self?.viewModel.typeAboutMe($0) })
            .disposed(by: disposeBag)
        
        selectContactTypeButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let indexOfContactTypeBeingSelected = self?.indexOfContactTypeBeingSelected   else { return }
                guard let selectedIndex = self?.contactTypePickerView?.selectedRow(inComponent: 0)  else { return }
                guard let contactType = ContactType.allCases[safe: selectedIndex]                   else { return }
                
                self?.viewModel.selectContactType(contactType, index: indexOfContactTypeBeingSelected)
            })
            .disposed(by: disposeBag)
        
        completeButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapCompletion()
            })
            .disposed(by: self.disposeBag)
        
        self.view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: CardCreationViewModel) {
        if let profilePlaceholderView = self.profilePlaceholderView {
            viewModel.shouldHideProfilePlaceholder
                .distinctUntilChanged()
                .bind(to: profilePlaceholderView.rx.isHidden)
                .disposed(by: self.disposeBag)
        }
        
        if let profileImageView = self.profileImageView {
            viewModel.profileImageSource
                .distinctUntilChanged()
                .bind(to: profileImageView.rx.imageSource)
                .disposed(by: self.disposeBag)
        }
        
        viewModel.profileBackgroundColor
            .distinctUntilChanged()
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
            viewModel.role
                .distinctUntilChanged()
                .bind(to: roleField.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let personalityTextView = self.personalityTextView {
            viewModel.personality
                .distinctUntilChanged()
                .bind(to: personalityTextView.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let personalityPlaceholder = self.personalityPlaceholder {
            viewModel.shouldHidePersonalityPlaceholder
                .distinctUntilChanged()
                .bind(to: personalityPlaceholder.rx.isHidden)
                .disposed(by: self.disposeBag)
        }
        
        if let aboutMeTextView = self.aboutMeTextView {
            viewModel.aboutMe
                .distinctUntilChanged()
                .bind(to: aboutMeTextView.rx.text)
                .disposed(by: disposeBag)
        }
        
        viewModel.isLoading.distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: disposeBag)
        
        viewModel.hasCompletedSkillInput
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] hasCompleted in
                if hasCompleted {
                    self?.skillCompleteImageView?.image = UIImage(named: "icon_complete")
                    self?.mySkillSettingButton?.backgroundColor = Palette.lightGreen
                } else {
                    self?.skillCompleteImageView?.image = UIImage(named: "icon_incomplete")
                    self?.mySkillSettingButton?.backgroundColor = .white
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.hasCompletedTMIInput
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] hasCompleted in
                if hasCompleted {
                    self?.tmiCompleteImageView?.image = UIImage(named: "icon_complete")
                    self?.myTMISettingButton?.backgroundColor = Palette.lightGreen
                } else {
                    self?.tmiCompleteImageView?.image = UIImage(named: "icon_incomplete")
                    self?.myTMISettingButton?.backgroundColor = .white
                }
            })
            .disposed(by: disposeBag)
        
        if let profileClearButton = self.profileClearButton {
            viewModel.shouldHideClear
                .distinctUntilChanged()
                .bind(to: profileClearButton.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
        if let aboutMePlaceholderLabel = self.aboutMePlaceholderLabel {
            viewModel.aboutMe
                .map { $0.isEmpty == false }
                .distinctUntilChanged()
                .bind(to: aboutMePlaceholderLabel.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
        if let completeButton = self.completeButton {
            viewModel.canComplete.distinctUntilChanged()
                .do { [weak self] canComplete in
                    self?.completeButton?.backgroundColor = canComplete ? Palette.black1 : Palette.gray1
                }
                .bind(to: completeButton.rx.isEnabled)
                .disposed(by: disposeBag)
        }
        
        viewModel.contactInfos
            .subscribe(onNext: { [weak self] contactInfos in
                contactInfos.enumerated().forEach { index, contactInfo in
                    guard let contactInputView = self?.contactInputViews?[safe: index] else { return }
                    contactInputView.configure(with: contactInfo)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.indexOfContactTypeBeingSelected
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] index in
                if let index = index,
                   let selected = self?.viewModel.contactInfos.value[safe: index],
                   let contactIndex = ContactType.allCases.firstIndex(of: selected.type) {
                    self?.contactTypePickerView?.selectRow(contactIndex, inComponent: 0, animated: false)
                }
                index == nil ? self?.hidePickerView() : self?.presentPickerView()
                self?.completeButton?.isHidden = index != nil
                self?.contactTypePickerView?.reloadComponent(0)
                self?.indexOfContactTypeBeingSelected = index
            }).disposed(by: disposeBag)
        
        viewModel.navigation
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] navigation in
                guard let viewController = self?.createViewController(of: navigation.destination) else { return }
                self?.navigate(viewController, action: navigation.action)
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldClose
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.shouldDismissOverlays
            .subscribe(onNext: { [weak self] in
                self?.presentedViewController?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func createViewController(of destination: CardCreationDestination) -> UIViewController? {
        switch destination {
        case .imageSourceTypePicker: return imageSourceTypePickerViewControllerFactory?()
        case .palette: return paletteViewControllerFactory?()
        case .createCharacter: return characterSettingViewControllerFactory?()
        case .settingSkill: return skillSettingViewControllerFactory?()
        case .settingTMI: return tmiSettingViewControllerFactory?()
        }
    }
    
    private func presentPickerView() {
        contactTypePickerView?.alpha = 0
        selectContactTypeButton?.alpha = 0
        contactTypePickerView?.isHidden = false
        selectContactTypeButton?.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.contactTypePickerView?.alpha = 1
            self.selectContactTypeButton?.alpha = 1
        })
    }
    
    private func hidePickerView() {
        contactTypePickerView?.alpha = 1
        selectContactTypeButton?.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            self.contactTypePickerView?.alpha = 0
            self.selectContactTypeButton?.alpha = 0
        }, completion: { _ in
            self.contactTypePickerView?.isHidden = true
            self.selectContactTypeButton?.isHidden = true
        })
    }
    
    private let disposeBag = DisposeBag()
    private let keyboard: Keyboard = KeyboardImpl.shared
    private let profileBackgroundColorButtonLayer = CAGradientLayer()
    private var indexOfContactTypeBeingSelected: Int? = nil
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var profileClearButton: UIButton?
    @IBOutlet private weak var profilePlaceholderView: UIView?
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var backgroundSettingButton: UIButton?
    @IBOutlet private weak var nameField: UITextField?
    @IBOutlet private weak var roleField: UITextField?
    
    @IBOutlet private weak var skillCompleteImageView: UIImageView?
    @IBOutlet private weak var mySkillSettingButton: UIButton?
    @IBOutlet private var contactInputViews: [ContactInputView]?
    
    @IBOutlet private weak var personalityTextView: UITextView?
    @IBOutlet private weak var personalityPlaceholder: UILabel?
    @IBOutlet private weak var personalityTextCountLabel: UILabel?
    @IBOutlet private weak var tmiCompleteImageView: UIImageView?
    @IBOutlet private weak var myTMISettingButton: UIButton?
    @IBOutlet private weak var aboutMeTextView: UITextView?
    @IBOutlet private weak var aboutMeTextCountLabel: UILabel?
    @IBOutlet private weak var aboutMePlaceholderLabel: UILabel?
    @IBOutlet private weak var keyboardFrameViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contactTypePickerView: UIPickerView?
    @IBOutlet private weak var selectContactTypeButton: UIButton?
    @IBOutlet private weak var completeButton: UIButton?
}
extension CardCreationViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ContactType.allCases.count
    }
    
}
extension CardCreationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ContactType.allCases[safe: row]?.description
    }
    
}
