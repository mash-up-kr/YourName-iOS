//
//  HomeViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import RxOptional
import RxSwift
import UIKit

final class MyCardListViewController: ViewController, Storyboarded {
    
    var viewModel: MyCardListViewModel!
    var cardDetailViewControllerFactory: ((String) -> CardDetailViewController)!
    @IBOutlet private weak var myCardAddButton: UIButton!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var myCardListCollectionview: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    var cardCreationViewControllerFactory: (() -> CardCreationViewController)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCardListCollectionview.decelerationRate = .fast
        myCardListCollectionview.isPagingEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        
        bind()
        userNameLabel.text = "서영님의 미츄(3)"
        pageControl.currentPage = 0
        
        //        #warning("카드 탭 액션 트리거 가구현, 실구현 후 제거해야합니다.") // Booung
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            //            self.viewModel.tapCard(at: 3)
            self.viewModel.tapCardCreation()
        })
    }
    
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: MyCardListViewModel) {
        viewModel.load()
        
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation}
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
        
        addCardButton?.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.viewModel.tapCardCreation() })
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
    
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var addCardButton: UIButton?
}

extension MyCardListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCardListEmptyCollectionViewCell", for: indexPath) as? MyCardListEmptyCollectionViewCell else { return .init() }
        return cell
    }
}
extension MyCardListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 312, height: 512)
    }
}
extension MyCardListViewController: UICollectionViewDelegateFlowLayout {
    
}
extension MyCardListViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        guard let layout = myCardListCollectionview.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // cell width + item사이거리
        let cellWidthIncludingSpacing = 312 + layout.minimumInteritemSpacing
        
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
