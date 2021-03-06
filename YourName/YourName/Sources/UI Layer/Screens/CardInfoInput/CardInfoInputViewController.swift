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


final class CardInfoInputViewController: ViewController, Storyboarded {
    
    var viewModel: CardInfoInputViewModel!
    var imageSourceTypePickerViewControllerFactory: (() -> ImageSourceTypePickerViewController)?
    var characterSettingViewControllerFactory: (() -> CharacterSettingViewController)?
    var paletteViewControllerFactory: ((Identifier?) -> PaletteViewController)?
    var tmiSettingViewControllerFactory: (([Interest], [StrongPoint]) -> TMISettingViewController)?
    var skillSettingViewControllerFactory: (([Skill]) -> SkillSettingViewController)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.viewModel.didLoad()
        self.setupUI()
        self.setupKeyboard()
        self.hidePickerView()
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
        profileImageView?.clipsToBounds = true
    }
    
    private func dispatch(to viewModel: CardInfoInputViewModel) {
        viewModel.didLoad()
        
        backButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel?.tapBack() })
            .disposed(by: self.disposeBag)
        
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
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.typePersonality(text[safe: 0..<40])
            })
            .disposed(by: disposeBag)
        
        myTMISettingButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapTMISetting() })
            .disposed(by: disposeBag)
        
        aboutMeTextView?.rx.text
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.typeAboutMe(text[safe: 0..<40])
            })
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
    
    private func render(_ viewModel: CardInfoInputViewModel) {
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
                .bind(to: personalityTextView.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let personalityPlaceholder = self.personalityPlaceholder {
            viewModel.personality
                .map { $0.isNotEmpty }
                .distinctUntilChanged()
                .bind(to: personalityPlaceholder.rx.isHidden)
                .disposed(by: disposeBag)
        }
        viewModel.personalityTextStatus
            .subscribe(onNext: { [weak self] status in
                self?.personalityTextCountLabel?.text = "\(status.count)"
                self?.personalityTextCountLabel?.textColor = status.isFull ? UIColor(hexString: "#EB1616") : Palette.black1
                self?.personalityTextMaxCountLabel?.text = "\(status.max)"
            })
            .disposed(by: disposeBag)
        
        if let aboutMeTextView = self.aboutMeTextView {
            viewModel.aboutMe
                .bind(to: aboutMeTextView.rx.text)
                .disposed(by: disposeBag)
        }
        
        if let aboutMePlaceholderLabel = self.aboutMePlaceholderLabel {
            viewModel.aboutMe
                .map { $0.isNotEmpty }
                .distinctUntilChanged()
                .bind(to: aboutMePlaceholderLabel.rx.isHidden)
                .disposed(by: disposeBag)
        }
        
        viewModel.aboutMeTextStatus
            .subscribe(onNext: { [weak self] status in
                self?.aboutMeTextCountLabel?.text = "\(status.count)"
                self?.aboutMeTextCountLabel?.textColor = status.isFull ? UIColor(hexString: "#EB1616") : Palette.black1
                self?.aboutMeTextMaxCountLabel?.text = "\(status.max)"
            })
            .disposed(by: disposeBag)
        
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
        case .imageSourceTypePicker:
            return imageSourceTypePickerViewControllerFactory?()
        case .palette(let selectedColorID):
            return paletteViewControllerFactory?(selectedColorID)
        case .createCharacter:
            return characterSettingViewControllerFactory?()
        case .settingSkill(let skills):
            return skillSettingViewControllerFactory?(skills ?? [])
        case .settingTMI(let interests, let strongPoints):
            return tmiSettingViewControllerFactory?(interests ?? [], strongPoints ?? [])
        case .photoLibrary:
            return UIImagePickerController().then {
                $0.sourceType = .photoLibrary
                $0.allowsEditing = true
                $0.delegate = self
            }
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
    
    private func setupKeyboard() {
        if let aboutMeTextView = self.aboutMeTextView {
            Observable.merge(
                aboutMeTextView.rx.didBeginEditing.map { _ in true },
                aboutMeTextView.rx.didEndEditing.map { _ in false }
            ).subscribe(onNext: { [weak self] isEditing in
                if isEditing {
                    UIView.animate(withDuration: 0.3) {
                        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
                        self?.scrollView?.contentInset = contentInset
                        self?.scrollView?.contentOffset.y += 250
                    }
                }
                else {
                    UIView.animate(withDuration: 0.3) {
                        self?.scrollView?.contentInset = UIEdgeInsets.zero
                    }
                }
            }).disposed(by: self.disposeBag)
        }
    }
    
    private let disposeBag = DisposeBag()
    private let profileBackgroundColorButtonLayer = CAGradientLayer()
    private var indexOfContactTypeBeingSelected: Int? = nil
    
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var backButton: UIButton?
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
    @IBOutlet private weak var personalityTextMaxCountLabel: UILabel?
    
    @IBOutlet private weak var tmiCompleteImageView: UIImageView?
    @IBOutlet private weak var myTMISettingButton: UIButton?
    
    @IBOutlet private weak var aboutMeTextView: UITextView?
    @IBOutlet private weak var aboutMePlaceholderLabel: UILabel?
    @IBOutlet private weak var aboutMeTextCountLabel: UILabel?
    @IBOutlet private weak var aboutMeTextMaxCountLabel: UILabel?
    
    @IBOutlet private weak var keyboardFrameViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contactTypePickerView: UIPickerView?
    @IBOutlet private weak var selectContactTypeButton: UIButton?
    @IBOutlet private weak var completeButton: UIButton?
}
extension CardInfoInputViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ContactType.allCases.count
    }
    
}
extension CardInfoInputViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ContactType.allCases[safe: row]?.description
    }
    
}

extension CardInfoInputViewController: UINavigationControllerDelegate {}

extension CardInfoInputViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage, let data = image.pngData() else { return }
        self.presentedViewController?.dismiss(animated: true, completion: {
            self.viewModel.selectPhoto(data: data)
        })
    }
}
