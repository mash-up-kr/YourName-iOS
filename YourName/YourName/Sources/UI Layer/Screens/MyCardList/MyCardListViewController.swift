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
    
    @IBOutlet private unowned var userNameLabel: UILabel!
    @IBOutlet private unowned var myCardListCollectionView: UICollectionView!
    @IBOutlet private unowned var pageControl: UIPageControl!
    @IBOutlet private unowned var addCardButton: UIButton!
    
    // MARK: - Properties
    
    var cardCreationViewControllerFactory: (() -> CardCreationViewController)!
    var cardDetailViewControllerFactory: ((String) -> CardDetailViewController)!
    var viewModel: MyCardListViewModel!
    private let disposeBag = DisposeBag()
    private lazy var collectionViewWidth = ( 312 * self.myCardListCollectionView.bounds.height ) / 512
    
    /* Dummy */
    private let dummyData = [Palette.lightGreen, Palette.orange, Palette.pink]
    private let content = [ CardFrontView.Item(image: "",
                                            name: "서영부캐1",
                                            role: "역할이 길면 짤려야합니다.짤려야한다고!!!",
                                            skills: [.init(title: "인사력", level: 10),
                                                     .init(title: "잠만보", level: 1)],
                                            backgroundColor: Palette.vilolet),
                            CardFrontView.Item(image: "",
                                            name: "서영 본캐입니다.",
                                            role: "역할",
                                            skills: [
                                                .init(title: "뭐하지", level: 3),
                                                .init(title: "스킬은", level: 5)
                                                ],
                                            backgroundColor: Palette.yellow),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure(colletionView: myCardListCollectionView)
        self.dispatch(to: viewModel)
        self.navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Methods
extension MyCardListViewController {
    
    private func configure(colletionView: UICollectionView) {
        colletionView.decelerationRate = .fast
        colletionView.isPagingEnabled = false
        colletionView.registerNib(MyCardListEmptyCollectionViewCell.self)
        colletionView.registerNib(MyCardListCollectionViewCell.self)
    }
    
    private func dispatch(to viewModel: MyCardListViewModel) {
        viewModel.load()
        
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation }
        .bind(onNext: { [weak self] action in
            guard let self = self else { return }
            self.navigate(action)
        }).disposed(by: disposeBag)
        
        self.addCardButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.tapCardCreation()
            })
            .disposed(by: disposeBag)
        
        // TODO: ViewModel observe하는 방식으로 수정
        self.pageControl.numberOfPages = content.count
        self.pageControl.currentPage = 0
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

//MARK: - UICollectionViewDataSource
extension MyCardListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: API 연결 이후 enum타입으로 정의할 예정
        if content.count == 1 {
            guard let cell = collectionView.dequeueReusableCell(MyCardListEmptyCollectionViewCell.self,
                                                                for: indexPath)
            else { return .init() }
            
            let didSelect: (() -> Void) = { [weak self] in
                self?.viewModel.tapCardCreation()
            }
            cell.didSelect = didSelect
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(MyCardListCollectionViewCell.self,
                                                                for: indexPath),
                  let myCardView = cell.contentView as? CardFrontView else { return .init() }
            myCardView.configure(item: content[indexPath.row])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MyCardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (312 * collectionView.bounds.height) / 512,
                      height: collectionView.bounds.height)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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
        
        guard let layout = myCardListCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
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
