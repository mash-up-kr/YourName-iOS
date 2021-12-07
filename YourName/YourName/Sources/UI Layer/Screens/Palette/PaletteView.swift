//
//  PaletteView.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import RxSwift
import RxCocoa
import UIKit

typealias PaletteViewController = PageSheetController<PaletteView>

final class PaletteView: UIView, NibLoadable {
    var parent: ViewController?
    var viewModel: PaletteViewModel! {
        didSet { bind(to: viewModel) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.colorsCollectionView?.registerWithNib(ColorSourceCollectionViewCell.self)
        self.colorsCollectionView?.dataSource = self
        self.colorsCollectionView?.delegate = self
    }
    
    private func bind(to viewModel: PaletteViewModel) {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: PaletteViewModel) {
        self.viewModel.didLoad()
        
        colorsCollectionView?.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.selectColor(at: indexPath.item)
            })
            .disposed(by: self.disposeBag)
        
        completeButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapComplete()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: PaletteViewModel) {
        self.viewModel.profileColors
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] profileColors in
                self?.profileColors = profileColors
                self?.colorsCollectionView?.reloadData()
            })
            .disposed(by: disposeBag)
        
        if let completeButton = self.completeButton {
            self.viewModel.canBeCompleted
                .distinctUntilChanged()
                .bind(to: completeButton.rx.isEnabled)
                .disposed(by: disposeBag)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    private var selectedIndex: Int?
    private var profileColors: [YourNameColor] = []
    
    @IBOutlet private weak var colorsCollectionView: UICollectionView?
    @IBOutlet private weak var completeButton: UIButton?
    
}
extension PaletteView: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return profileColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ColorSourceCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
        guard let profileColor = profileColors[safe: indexPath.row] else { return cell }
        cell.configure(profileColor: profileColor)
        return cell
    }

}
extension PaletteView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 21, left: 24, bottom: 24, right: 21)
    }
}

extension PaletteView: PageSheetContentView {
    var title: String { "배경 컬러 선택하기" }
    var isModal: Bool { false }
}
