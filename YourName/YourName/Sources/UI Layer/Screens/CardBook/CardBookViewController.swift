//
//  CardBookViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import RxSwift
import RxCocoa

final class CardBookViewController: ViewController, Storyboarded {
   
    
    @IBOutlet private weak var cardBookTitleLabel: UILabel!
    @IBOutlet private weak var addCardButton: UIButton!
    @IBOutlet private weak var cardBookCollectionView: UICollectionView!

    private enum Constant {
        static let collectionViewSectionInset = 24
        static let collectionViewCellSpacing = 19
    }
    var dummyDataNumber = 10 // dummy
    var viewModel: CardBookViewModel!
    var addCardViewControllerFactory: (() -> AddCardViewController)!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
}
extension CardBookViewController {
    private func dispatch(to viewModel: CardBookViewModel) {
        self.rx.viewDidAppear.flatMapFirst { _ in self.viewModel.navigation}
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.navigate(action)
            }).disposed(by: disposeBag)
        
        addCardButton.rx.throttleTap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.tapSearchButton()
            })
            .disposed(by: disposeBag)
    }
    private func bind() {
        dispatch(to: viewModel)
        render(viewModel)
    }
    private func render(_ veiwModel: CardBookViewModel) {
        // render함수의 용도..?
    }
    private func navigate(_ navigation: CardBookNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    private func createViewController(_ next: CardBookDestination) -> UIViewController {
        switch next {
        case .addCard:
            return addCardViewControllerFactory()
        }
    }
    private func configureCollectionView() {
        cardBookCollectionView.registerWithNib(CardBookCollectionViewCell.self)
        cardBookCollectionView.registerWithNib(CardBookEmptyCollectionViewCell.self)
    }
}

// TODO: rx datasource로 추후 교체예정
extension CardBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyDataNumber
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(CardBookCollectionViewCell.self, for: indexPath)
        else { return .init() }
        
        return cell
    }
}
extension CardBookViewController: UICollectionViewDelegate {
}
extension CardBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width 154 height 241
        let width = Int(UIScreen.main.bounds.width) - (Constant.collectionViewSectionInset * 2) - Constant.collectionViewCellSpacing
        return CGSize(width: width / 2,
                      height: (241 * (width / 2)) / 154)
    }
}
