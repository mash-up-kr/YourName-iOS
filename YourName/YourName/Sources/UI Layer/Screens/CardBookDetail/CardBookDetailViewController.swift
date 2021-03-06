//
//  CardBookViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import RxSwift
import RxCocoa
 
final class CardBookDetailViewController: ViewController, Storyboarded {
   
    private enum Constant {
        static let collectionViewSectionInset = 24
        static let collectionViewCellSpacing = 19
    }
    
    var viewModel: CardBookDetailViewModel!
    var cardBookMoreViewControllerFactory: ((String, Bool) -> CardBookMoreViewController)!
    var addFriendCardViewControllerFactory: (() -> AddFriendCardViewController)!
    var nameCardDetailViewControllerFactory: ((CardBookID?, Identifier, UniqueCode) -> NameCardDetailViewController)!
    var allCardBookDetailViewControllerFactory: ((CardBookID) -> CardBookDetailViewController)!
    var editCardBookViewControllerFactory: ((CardBookID) -> AddCardBookViewController)!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
        
        Observable.merge(
            NotificationCenter.default.rx.notification(.friendCardDidDelete),
            NotificationCenter.default.rx.notification(.cardBookDetailDidChange),
            NotificationCenter.default.rx.notification(.cardBookDidChange)
        )
        .bind(onNext: { [weak self] _ in
            self?.viewModel.fetchCards()
            self?.viewModel.fetchCardBookInfo()
        })
        .disposed(by: self.disposeBag)
    }
    
    private func dispatch(to viewModel: CardBookDetailViewModel) {
        self.viewModel.didLoad()
        
        self.rx.viewDidAppear
            .flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
        
        self.backButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapBack()
            })
            .disposed(by: self.disposeBag)
        
        self.moreButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapMore()
            })
            .disposed(by: self.disposeBag)
        
        self.removeButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapRemoveButton()
            })
            .disposed(by: self.disposeBag)
        
        self.bottomRemoveButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapBottomButton()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: CardBookDetailViewModel) {
        self.viewModel.cardBookTitle.distinctUntilChanged()
            .subscribe(onNext: { [weak self] cardBookTitle in
                self?.cardBookTitleLabel?.text = cardBookTitle
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.isLoading.distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        
        self.viewModel.friendCardsForDisplay.distinctUntilChanged()
            .subscribe(onNext: { [weak self] cellViewModels in
                self?.cellViewModels = cellViewModels
                self?.friendCardCollectionView?.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.isEditing
            .withLatestFrom(self.viewModel.isAllCardBook) { ($0, $1) }
            .bind(onNext: { [weak self] isEditing, isAllCardBook in
                if isAllCardBook {
                    self?.removeButton?.isHidden = isEditing
                } else {
                    self?.moreButton?.isHidden = isEditing
                }
                self?.bottomRemoveButton?.isHidden = !isEditing
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.isAllCardBook
            .filter { $0 }
            .withLatestFrom(viewModel.state) { ($0, $1) }
            .subscribe(onNext: { [weak self] _, migrate in
                switch migrate {
                case .migrate:
                    self?.moreButton?.isHidden = true
                    self?.removeButton?.isHidden = true
                case .normal:
                    self?.moreButton?.isHidden = true
                    self?.removeButton?.isHidden = false
                }
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.isAllCardBook
            .filter { !$0 }
            .bind(onNext: { [weak self] _ in
                self?.moreButton?.isHidden = false
                self?.removeButton?.isHidden = true
            })
            .disposed(by: self.disposeBag)
                
        self.viewModel.shouldShowRemoveReconfirmAlert
            .subscribe(onNext: { alertItem in
                let alertController = AlertViewController.instantiate()
                alertController.configure(item: alertItem)
                self.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.shouldClose
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.checkedCardIndice
            .filter { $0.isEmpty }
            .bind(onNext: { [weak self] _ in
                self?.bottomRemoveButton?.isUserInteractionEnabled = false
                self?.bottomRemoveButton?.backgroundColor = Palette.gray1
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.checkedCardIndice
            .filter { !$0.isEmpty }
            .bind(onNext: { [weak self] _ in
                self?.bottomRemoveButton?.isUserInteractionEnabled = true
                self?.bottomRemoveButton?.backgroundColor = Palette.black1
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.state
            .bind(onNext: { [weak self] state in
                switch state {
                case .migrate:
                    self?.bottomRemoveButton?.setTitle("????????????", for: .normal)
                case .normal:
                    self?.bottomRemoveButton?.setTitle("????????????", for: .normal)
                }
            })
            .disposed(by: self.disposeBag)
        
        viewModel.shouldPopViewController
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)

    }
    
    private func navigate(_ navigation: CardBookDetailNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: CardBookDetailDestination) -> UIViewController {
        switch next {
        case .cardDetail(let cardBookID, let cardId, let uniqueCode):
            return self.nameCardDetailViewControllerFactory(cardBookID, cardId, uniqueCode)
        case .cardBookMore(let cardBookName, let isCardEmpty):
            return self.cardBookMoreViewControllerFactory(cardBookName, isCardEmpty)
        case .allCardBook(let cardBookId):
            return self.allCardBookDetailViewControllerFactory(cardBookId)
        case .editCardBook(let cardBookId):
            return self.editCardBookViewControllerFactory(cardBookId)
        }
    }
    
    private func configureCollectionView() {
        friendCardCollectionView?.registerWithNib(FriendCardCollectionViewCell.self)
        friendCardCollectionView?.registerWithNib(FriendCardEmptyCollectionViewCell.self)
        friendCardCollectionView?.dataSource = self
        friendCardCollectionView?.delegate = self
    }
    
    private let disposeBag = DisposeBag()
    
    private var isCardEditing = false
    private var cellViewModels: [FriendCardCellViewModel] = []
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var moreButton: UIButton?
    @IBOutlet private weak var removeButton: UIButton?
    @IBOutlet private weak var cardBookTitleLabel: UILabel?
    @IBOutlet private weak var friendCardCollectionView: UICollectionView?
    @IBOutlet private weak var bottomRemoveButton: UIButton?
    @IBOutlet private weak var bottomBarView: UIView?

}

// TODO: rx datasource??? ?????? ????????????
extension CardBookDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.cellViewModels.isNotEmpty {
            return self.cellViewModels.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.cellViewModels.isNotEmpty {
            return friendCardCell(indexPath: indexPath)
        } else {
            return emptyCell(indexPath: indexPath)
        }
    }
    
    private func friendCardCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.friendCardCollectionView?.dequeueReusableCell(FriendCardCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        guard let cellViewModel = self.cellViewModels[safe: indexPath.row] else { return cell }
        cell.configure(with: cellViewModel)
        return cell
    }
    
    private func emptyCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.friendCardCollectionView?.dequeueReusableCell(FriendCardEmptyCollectionViewCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}

extension CardBookDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.cellViewModels.isNotEmpty else { return }
        self.viewModel.tapCard(at: indexPath.item)
    }
    
}

extension CardBookDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width 154 height 241
        let width = Int(UIScreen.main.bounds.width) - (Constant.collectionViewSectionInset * 2) - Constant.collectionViewCellSpacing
        return CGSize(width: width / 2,
                      height: (241 * (width / 2)) / 154)
    }
}
