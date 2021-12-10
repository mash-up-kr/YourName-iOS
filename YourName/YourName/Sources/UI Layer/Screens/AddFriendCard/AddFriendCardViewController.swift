//
//  AddFriendCardViewController.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class AddFriendCardViewController: ViewController, Storyboarded {
    
    typealias FriendCardState = AddFriendCardViewModel.FriendCardState
    
    @IBOutlet private unowned var noResultView: AddFriendCardNoResultView!
    @IBOutlet private unowned var searchTextField: UITextField!
    @IBOutlet private unowned var validationLabel: UILabel!
    @IBOutlet private unowned var searchButton: UIButton!
    @IBOutlet private unowned var backButton: UIButton!
    private let resultView = AddFriendCardResultView()
    private let addButton = UIButton().then {
        $0.setTitle("추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        $0.backgroundColor = Palette.black1
        $0.cornerRadius = 12
    }
    
    
    private let disposeBag = DisposeBag()
    private let searchId = PublishRelay<String>()
    var viewModel: AddFriendCardViewModel!
    var cardDetailViewControllerFactory: ((Identifier) -> NameCardDetailViewController)!
    
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

// MARK: - Configure UI Methods
extension AddFriendCardViewController {
    
    private func configureInitialUI() {
        self.view.addSubviews(self.resultView, self.addButton)
        self.resultViewLayout()
        self.addButtonLayout()
        
        self.searchTextField.becomeFirstResponder()
        [self.noResultView, self.resultView, self.validationLabel, self.addButton].forEach { $0.isHidden = true }
        self.searchTextField.layer.borderColor = Palette.gray1.cgColor
        self.searchTextField.leftView = UIView(frame: .init(x: 0, y: 0, width: 11, height: self.searchTextField.bounds.height))
        self.searchTextField.leftViewMode = .always
    }
    
    private func resultViewLayout() {
        self.resultView.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.top.equalTo(self.searchTextField.snp.bottom).offset(20)
            
            $0.height.equalTo((UIScreen.main.bounds.height * 512 / 812))  // 명함 사이즈 비율에 맞춰 보여질 수 있도록
            let width = (UIScreen.main.bounds.height * 512 / 812) * (312 / 512)
            $0.width.equalTo(width)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func addButtonLayout() {
        self.addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(44)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
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
        button.setTitle("추가하기", for: .normal)
        
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
        case .isMine:
            button.isHidden = false
            button.isEnabled = false
            button.setTitle("내 미츄는 도감에 등록할 수 없습니다", for: .normal)
            button.backgroundColor = Palette.gray1
        }
    }
    
}

extension AddFriendCardViewController {
    
    // MARK: - Bind
    private func bind() {
        
        Observable.merge(
            self.searchTextField.rx.controlEvent([.editingDidEndOnExit])
                .mapToVoid(),
            self.resultView.rx.tapWhenRecognized
                .mapToVoid(),
            self.noResultView.rx.tapWhenRecognized
                .mapToVoid(),
            self.view.rx.tapWhenRecognized
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
                guard let self = self else { return }
                self.searchId.accept(id)
                [self.noResultView, self.resultView, self.validationLabel, self.addButton].forEach { $0?.isHidden = true }
                self.configure(self.searchTextField, for: .noResult)
            })
            .disposed(by: disposeBag)
        
        self.searchButton.rx.throttleTap
            .withLatestFrom(searchId)
            .bind(onNext: { [weak self] id in
                self?.searchTextField.resignFirstResponder()
                self?.viewModel.searchMeetu(with: id)
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
                self.configureLayout(state)
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
                    
                    self.resultView.configure(frontCardItem: frontItem,
                                              backCardItem: backItem)
                    
                    
                    // MARK: 이미 추가된 경우
                case .isAdded(let frontItem, let backItem):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = false

                    self.resultView.configure(frontCardItem: frontItem,
                                              backCardItem: backItem)
                    
                    
                    // MARK: 내 명함인 경우
                case .isMine(let frontItem, let backItem):
                    self.noResultView.isHidden = true
                    self.resultView.isHidden = false
                    self.validationLabel.isHidden = true
                    
                    self.resultView.configure(frontCardItem: frontItem,
                                              backCardItem: backItem)
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
        self.navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: AddFriendCardDestination) -> UIViewController {
        switch next {
        case .cardDetail(let cardID):
            return cardDetailViewControllerFactory(cardID)
        }
    }
    
    private func configureLayout(_ state: FriendCardState) {
        self.resultView.snp.remakeConstraints { [weak self] in
            var topOffset = 0
            switch state {
            case .success:
                topOffset = 20
            case .isAdded:
                topOffset = 37
            default:
                break
            }
            
            guard let self = self else { return }
            $0.top.equalTo(self.searchTextField.snp.bottom).offset(topOffset)
            
            $0.height.equalTo((UIScreen.main.bounds.height * 512 / 812))  // 명함 사이즈 비율에 맞춰 보여질 수 있도록
            let width = (UIScreen.main.bounds.height * 512 / 812) * (312 / 512)
            $0.width.equalTo(width)
            $0.centerX.equalToSuperview()
        }

        self.addButton.snp.remakeConstraints { 
            var bottomInset = 0
            switch state {
            case .isAdded:
                bottomInset = 31
            case .success:
                bottomInset = 44
            default:
                break
            }
            $0.bottom.equalToSuperview().inset(bottomInset)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
   
        self.view.layoutIfNeeded()
    }
}
