//
//  SelectCardBookViewController.swift
//  MEETU
//
//  Created by seori on 2021/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift
import SnapKit

final class SelectCardBookViewController: ViewController, Storyboarded {

    @IBOutlet private unowned var backButton: UIButton!
    @IBOutlet private unowned var addCardBookButton: UIButton!
    @IBOutlet private unowned var cardBookCollectionView: UICollectionView!
    @IBOutlet private unowned var completeButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: SelectCardBookViewModel!
    private let checkedIndex = BehaviorRelay<[IndexPath]>(value: [])
    
    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configureUI()
        self.render(viewModel)
    }
}

extension SelectCardBookViewController {
    private func bind() {
        self.backButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        self.addCardBookButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.viewModel.didTapAddCardButton()
            })
            .disposed(by: disposeBag)
        
        self.completeButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.viewModel.didTapCompleteButton()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        self.cardBookCollectionView.registerWithNib(SelectCardBookCollectionViewCell.self)
    }
    private func render(_ viewModel: SelectCardBookViewModel) {
        viewModel.isEnabledCompleteButton
            .bind(onNext: { [weak self] isEnabled in
                self?.completeButton.isEnabled = isEnabled
                if isEnabled {
                    self?.completeButton.backgroundColor = Palette.black1
                } else {
                    self?.completeButton.backgroundColor = Palette.gray1
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.toastView
            .bind(onNext: { [weak self] in
                self?.navigationController?.view.showToast($0, position: .top, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension SelectCardBookViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SelectCardBookCollectionViewCell.self, for: indexPath) else { return .init() }
        
        guard let item = self.viewModel.cellForItem(at: indexPath) else { return .init() }
        cell.configure(item: item)
        cell.checkboxDidTap = { [weak self] in
            self?.viewModel.didSelectCardBook(at: indexPath)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SelectCardBookViewController: UICollectionViewDelegate {
}

extension SelectCardBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 77)
    }
}
