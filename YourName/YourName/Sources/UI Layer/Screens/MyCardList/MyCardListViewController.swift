//
//  HomeViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import RxOptional
import RxSwift
import RxCocoa
import UIKit

final class MyCardListViewController: ViewController, Storyboarded {

    private enum Constant {
        static let collectionViewSectionInset: CGFloat = 24
    }
    
    // MARK: - UIComponents
    
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var myCardListCollectionview: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var addCardButton: UIButton!
    
    // MARK: - Properties
    var cardCreationViewControllerFactory: (() -> CardCreationViewController)!
    var cardDetailViewControllerFactory: ((String) -> CardDetailViewController)!
    var viewModel: MyCardListViewModel!
    private let disposeBag = DisposeBag()
    private lazy var collectionViewWidth = ( 312 * self.myCardListCollectionview.bounds.height ) / 512
    private let dummyData = [Palette.lightGreen, Palette.orange]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        configureCollectionView()
        bind()
    }
}

// MARK: - Methods
extension MyCardListViewController {
    
    private func configureCollectionView() {
        myCardListCollectionview.decelerationRate = .fast
        myCardListCollectionview.isPagingEnabled = false
        myCardListCollectionview.registerWithNib(MyCardListEmptyCollectionViewCell.self)
        myCardListCollectionview.registerWithNib(MyCardListCollectionViewCell.self)
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
        
        // TODO: ViewModel observe하는 방식으로 수정
        pageControl.numberOfPages = dummyData.count
        pageControl.currentPage = 0
        
    }
    
    private func dispatch(to viewModel: MyCardListViewModel) {
        viewModel.load()
        
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation}
        .bind(onNext: { [weak self] action in
            guard let self = self else { return }
            self.navigate(action)
        }).disposed(by: disposeBag)
        
        addCardButton?.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.tapCardCreation()
            })
            .disposed(by: disposeBag)
    }
    
    private func render(_ viewModel: MyCardListViewModel) {
        
    }
    
    private func navigate(_ navigation: MyCardListNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    
    private func createViewController(_ next: MyCardListDesitination) -> UIViewController {
        switch next {
        case .cardDetail(let cardID):
            return cardDetailViewControllerFactory(cardID)
        case .cardCreation:
            return cardCreationViewControllerFactory()
        }
    }
}

//TODO:  rxdatasource로 교체필요
extension MyCardListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if dummyData.count == 1 {
            guard let cell = collectionView.dequeueReusableCell(MyCardListEmptyCollectionViewCell.self,
                                                                for: indexPath)
            else { return .init() }
            
            cell.createCardButton.rx.throttleTap
                .bind(onNext: { [weak self] _ in
                    self?.viewModel.tapCardCreation()
                })
                .disposed(by: cell.disposeBag)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(MyCardListCollectionViewCell.self,
                                                                for: indexPath),
                  let myCardView = cell.contentView as? MyCardView else { return .init() }
            
            myCardView.backgroundColor = dummyData[indexPath.row]
            return cell
        }
    }
}
extension MyCardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (312 * collectionView.bounds.height) / 512,
               height: collectionView.bounds.height)
    }
}
extension MyCardListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if dummyData.count == 1 {
            let edges = UIScreen.main.bounds.width - collectionViewWidth
            return UIEdgeInsets(top: 0,
                                left: edges / 2,
                                bottom: 0,
                                right: edges / 2)
        } else {
            return UIEdgeInsets(top: 0,
                                left: Constant.collectionViewSectionInset,
                                bottom: 0,
                                right: Constant.collectionViewSectionInset)
        }
    }
}

extension MyCardListViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let layout = myCardListCollectionview.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // cell width + item사이거리
        let cellWidthIncludingSpacing = collectionViewWidth + layout.minimumInteritemSpacing
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        self.pageControl.currentPage = index
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
}
