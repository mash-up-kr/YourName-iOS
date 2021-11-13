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
    var dummyDataNumber = 10 // dummy
    var viewModel: CardBookDetailViewModel!
    var addFriendCardViewControllerFactory: (() -> AddFriendCardViewController)!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    private let disposeBag = DisposeBag()
    
    private var cellViewModels: [FriendCardCellViewModel] = []
    
    @IBOutlet private weak var backButton: UIButton?
    @IBOutlet private weak var moreButton: UIButton?
    @IBOutlet private weak var cardBookTitleLabel: UILabel?
    @IBOutlet private weak var friendCardCollectionView: UICollectionView?
}
extension CardBookDetailViewController {
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
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
    }
    
    private func render(_ veiwModel: CardBookDetailViewModel) {
        self.viewModel.cardBookTitle.distinctUntilChanged()
            .subscribe(onNext: { [weak self] cardBookTitle in
                self?.cardBookTitleLabel?.text = cardBookTitle
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.cellViewModels.distinctUntilChanged()
            .subscribe(onNext: { [weak self] cellViewModels in
                self?.cellViewModels = cellViewModels
                self?.friendCardCollectionView?.reloadData()
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.shouldClose
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func navigate(_ navigation: CardBookDetailNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: CardBookDetailDestination) -> UIViewController {
        return UIViewController()
        switch next {
        }
    }
    
    private func configureCollectionView() {
        friendCardCollectionView?.registerNib(FriendCardCollectionViewCell.self)
        friendCardCollectionView?.registerNib(FriendCardEmptyCollectionViewCell.self)
        friendCardCollectionView?.dataSource = self
        friendCardCollectionView?.delegate = self
    }
}

// TODO: rx datasource로 추후 교체예정
extension CardBookDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.cellViewModels.isEmpty {
            return emptyCell(indexPath: indexPath)
        } else {
            return friendCardCell(indexPath: indexPath)
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

extension CardBookDetailViewController: UICollectionViewDelegate {}

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
