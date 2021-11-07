//
//  AddFriendCardViewController.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit
import RxSwift
import RxCocoa

final class AddFriendCardViewController: ViewController, Storyboarded {
    
    @IBOutlet private unowned var resultView: AddFriendCardResultView!
    @IBOutlet private unowned var noResultView: AddFriendCardNoResultView!
    @IBOutlet private unowned var searchTextField: UITextField!
    @IBOutlet private unowned var validationLabel: UILabel!
    @IBOutlet private unowned var searchButton: UIButton!
    @IBOutlet private unowned var backButton: UIButton!
    @IBOutlet private unowned var resultViewTopConstraints: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    var viewModel: AddFriendCardViewModel!
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.render(self.viewModel)
        self.bind()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.configureTextFieldLeftView()
    }
}

// MARK: - Methods
extension AddFriendCardViewController {
    private func configureUI() {
        self.searchTextField.becomeFirstResponder()
        [self.noResultView, self.resultView, self.validationLabel].forEach { $0?.isHidden = true }
        
        configure(self.searchTextField)
    }
    private func configureTextFieldLeftView() {
        self.searchTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 11, height: self.searchTextField.frame.height))
        self.searchTextField.leftViewMode = .always
    }
    private func bind() {
        
        Observable.merge(
            self.searchTextField.rx.controlEvent([.editingDidEndOnExit])
                .mapToVoid(),
            self.resultView.rx.tapWhenRecognized()
                .mapToVoid(),
            self.noResultView.rx.tapWhenRecognized()
                .mapToVoid(),
            self.view.rx.tapWhenRecognized()
                .mapToVoid()
            )
            .bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        let searchId = PublishRelay<String>()
        
        self.searchTextField.rx.text
            .compactMap { $0 }
            .bind(to: searchId)
            .disposed(by: disposeBag)
        
        self.searchButton.rx.throttleTap
            .withLatestFrom(searchId)
            .bind(onNext: { [weak self] id in
                self?.viewModel.didTapSearchButton(with: id)
            })
            .disposed(by: disposeBag)
        
        self.backButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.closeOverlayViewControllers()
            })
            .disposed(by: disposeBag)
    }
    
    private func configure(_ textField: UITextField,
                           state: AddFriendCardViewModel.CardState = .none) {
        textField.layer.borderWidth = 1
        switch state {
        case .alreadyAdded:
            textField.layer.borderColor = Palette.red.cgColor
        default:
            textField.layer.borderColor = Palette.gray1.cgColor
        }
    }
    
    private func render(_ viewModel: AddFriendCardViewModel) {
        
        self.viewModel.addFriendCardResult
            .bind(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                    // MARK: 결과가 없는 경우
                case .noResult:
                    self.noResultView.isHidden = false
                    self.resultView.isHidden = true
                    self.validationLabel.isHidden = true
                    self.configure(self.searchTextField)
                    
                    // MARK: 결과가 있는 경우
                case .success(let frontItem, let backItem):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = true
                    
                    self.resultViewTopConstraints.constant = 20
                    self.resultView.configureCardView(frontItem: frontItem,
                                                      backItem: backItem)
                    self.configure(self.searchTextField)
                    
                    // MARK: 이미 추가된 경우
                case .alreadyAdded(let frontItem, let backItem):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = false
                    
                    self.resultViewTopConstraints.constant = 37
                    self.resultView.configureCardView(frontItem: frontItem,
                                                      backItem: backItem)
                    self.configure(self.searchTextField, state: state)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
