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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        render(self.viewModel)
        bind()
    }
}

extension AddFriendCardViewController {
    private func configureUI() {
        self.searchTextField.becomeFirstResponder()
        [self.noResultView, self.resultView, self.validationLabel].forEach { $0?.isHidden = true }
        self.searchTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 11, height: searchTextField.bounds.height))
        self.searchTextField.leftViewMode = .always
        configure(self.searchTextField)
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
                print(state)
                guard let self = self else { return }
                switch state {
                case .noResult:
                    self.noResultView.isHidden = false
                    self.resultView.isHidden = true
                    self.validationLabel.isHidden = true
                    self.configure(self.searchTextField)
                case .success(let _):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = true
                    self.configure(self.searchTextField)
                case .alreadyAdded(let _):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = false
                    self.configure(self.searchTextField, state: state)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
