//
//  AddCardBookViewController.swift
//  MEETU
//
//  Created by Seori on 2022/02/07.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddCardBookViewModel: AnyObject {
    func fetchColors()
    func bgIsSelected(at indexPath: IndexPath)
    func didTapConfrim()
    func numberOfItemsInSection() -> Int
    func cellForItem(at indexPath: IndexPath) -> CardBookCoverBackgroundColorCell.Item?
    func cardBookName(text: String)
    func cardBookDesc(text: String)
    var cardBookCoverBgColors: BehaviorRelay<[CardBookCoverBackgroundColorCell.Item]> {get }
}

final class AddCardBookViewController: ViewController, Storyboarded {
    
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var cardBookCoverColorCollectionView: UICollectionView!
    @IBOutlet private weak var cardBookDescriptionTextField: UITextField!
    @IBOutlet private weak var cardBookNameTextField: UITextField!
    @IBOutlet private weak var backButton: UIButton!
    
    var viewModel: AddCardBookViewModel!
    private let disposeBag = DisposeBag()
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configure(self.cardBookNameTextField, self.cardBookDescriptionTextField)
        self.configure(self.cardBookCoverColorCollectionView)
        self.render(self.viewModel)
        self.dispatch(to: self.viewModel)
    }
    
    private func bind() {
        self.backButton.rx.throttleTap
            .bind(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.cardBookNameTextField.rx.text.orEmpty
            .bind(onNext: { [weak self] in
                self?.viewModel.cardBookName(text: $0)
            })
            .disposed(by: self.disposeBag)
        
        self.cardBookDescriptionTextField.rx.text.orEmpty
            .filter { $0.count < 10 }
            .bind(onNext: { [weak self] in
                self?.viewModel.cardBookDesc(text: $0)
            })
            .disposed(by: self.disposeBag)
        
        self.cardBookCoverColorCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] in
                self?.viewModel.bgIsSelected(at: $0)
            })
            .disposed(by: self.disposeBag)
        
        self.confirmButton.rx.throttleTap
            .bind(onNext: {[weak self] in
                self?.viewModel.didTapConfrim()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configure(_ collectionView: UICollectionView) {
        collectionView.registerWithNib(CardBookCoverBackgroundColorCell.self)
    }
    
    private func render(_ viewModel: AddCardBookViewModel) {
        viewModel.cardBookCoverBgColors
            .bind(onNext: { [weak self] _ in
                self?.cardBookCoverColorCollectionView.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
    private func dispatch(to viewModel: AddCardBookViewModel) {
        viewModel.fetchColors()
    }
    
    private func configure(_ textFields: UITextField...) {
        textFields.forEach { textField in
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            textField.borderWidth = 1
            textField.borderColor = Palette.lightGray3
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: textField.bounds.height))
            textField.leftViewMode = .always
        }
    }
}

extension AddCardBookViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        self.viewModel.numberOfItemsInSection()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cellModel = self.viewModel.cellForItem(at: indexPath),
              let cell = collectionView.dequeueReusableCell(
                CardBookCoverBackgroundColorCell.self,
                for: indexPath
              ) else { fatalError() }

        cell.configure(cellModel)
        return cell
    }
}

extension AddCardBookViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(width: 45, height: 45)
    }
}
