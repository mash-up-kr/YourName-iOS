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
    
    typealias FriendCardState = AddFriendCardViewModel.FriendCardState
    
    @IBOutlet private unowned var resultView: AddFriendCardResultView!
    @IBOutlet private unowned var noResultView: AddFriendCardNoResultView!
    @IBOutlet private unowned var searchTextField: UITextField!
    @IBOutlet private unowned var validationLabel: UILabel!
    @IBOutlet private unowned var searchButton: UIButton!
    @IBOutlet private unowned var backButton: UIButton!
    @IBOutlet private unowned var resultViewTopConstraints: NSLayoutConstraint!
    @IBOutlet private unowned var addButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let searchId = PublishRelay<String>()
    var viewModel: AddFriendCardViewModel!
    var cardDetailViewControllerFactory: ((Int) -> CardDetailViewController)!
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureInitialUI()
        self.render(self.viewModel)
        self.dispatch(to: self.viewModel)
        self.bind()
    }
}

extension AddFriendCardViewController {
    
    // MARK: - Configure UI Methods
    private func configureInitialUI() {
        self.searchTextField.becomeFirstResponder()
        [self.noResultView, self.resultView, self.validationLabel].forEach { $0?.isHidden = true }
        self.searchTextField.layer.borderColor = Palette.gray1.cgColor
        self.addButton.isHidden = true
        self.searchTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 11, height: self.searchTextField.bounds.height))
        self.searchTextField.leftViewMode = .always
    }
    
    private func configure(_ textField: UITextField,
                           for state: FriendCardState) {
        textField.layer.borderWidth = 1
        switch state {
        case .isAdded:
            textField.layer.borderColor = Palette.red.cgColor
        default:
            textField.layer.borderColor = Palette.gray1.cgColor
        }
    }
    
    private func configure(_ button: UIButton, for state: FriendCardState) {
        switch state {
        case .isAdded:
            button.backgroundColor = Palette.gray1
            button.isEnabled = false
            button.isHidden = false
        case .success:
            button.backgroundColor = Palette.black1
            button.isEnabled = true
            button.isHidden = false
        case .noResult:
            button.isHidden = true
        }
    }
    
}

extension AddFriendCardViewController {
    
    // MARK: - Bind
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
                self?.searchTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        self.searchTextField.rx.text
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(onNext: { [weak self] id in
                self?.searchId.accept(id)
                [self?.noResultView, self?.resultView, self?.validationLabel, self?.addButton].forEach { $0?.isHidden = true }
            })
            .disposed(by: disposeBag)
        
        self.searchButton.rx.throttleTap
            .withLatestFrom(searchId)
            .bind(onNext: { [weak self] id in
                self?.viewModel.didTapSearchButton(with: id)
            })
            .disposed(by: disposeBag)
        
        self.backButton.rx.throttleTap
            .bind(onNext: { [weak self]  in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        self.addButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.viewModel.didTapAddButton()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.friendCardDidAdded)
            .withLatestFrom(self.searchId)
            .bind(onNext: { [weak self] in
                self?.viewModel.didTapSearchButton(with: $0)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func render(_ viewModel: AddFriendCardViewModel) {
        
        viewModel.popViewController
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.alertController
            .bind(onNext: { [weak self] in
                self?.present($0, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.toastView
            .bind(onNext: { [weak self]  in
                self?.navigationController?.view.showToast($0, position: .top)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        
        viewModel.addFriendCardResult
            .bind(onNext: { [weak self] state in
                guard let self = self else { return }
                
                self.configure(self.addButton, for: state)
                self.configure(self.searchTextField, for: state)
                
                switch state {
                    // MARK: 결과가 없는 경우
                case .noResult:
                    self.noResultView.isHidden = false
                    self.resultView.isHidden = true
                    self.validationLabel.isHidden = true
                    
                    // MARK: 결과가 있는 경우
                case .success(let frontItem, let backItem):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = true
                    
                    self.resultViewTopConstraints.constant = 20
                    self.resultView.configure(frontCardItem: frontItem,
                                              backCardItem: backItem,
                                              friendCardState: state)
                    
                    // MARK: 이미 추가된 경우
                case .isAdded(let frontItem, let backItem):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = false
                    
                    self.resultViewTopConstraints.constant = 37
                    self.resultView.configure(frontCardItem: frontItem,
                                              backCardItem: backItem,
                                              friendCardState: state)
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func dispatch(to vieWModel: AddFriendCardViewModel) {
        self.rx.viewDidAppear
            .flatMapFirst ({ [weak self] _ -> Observable<AddFriendCardNavigation> in
                guard let self = self else { return .empty() }
                return self.viewModel.navigation.asObservable()
            })
            .bind(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            })
            .disposed(by: disposeBag)
    }
    
    private func navigate(_ navigation: AddFriendCardNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: AddFriendCardDestination) -> UIViewController {
        switch next {
        case .cardDetail(let cardID):
            return cardDetailViewControllerFactory(cardID)
        }
    }
}
