//
//  CategoryItemsViewController.swift
//  YourName
//
//  Created by Booung on 2021/10/06.
//

import UIKit
import RxSwift
import RxCocoa


final class DisplayCharacterItemsViewController: ViewController, Storyboarded {
    
    var viewModel: DisplayCharacterItemsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind(to: viewModel)
    }
    
    func setupUI() {
        itemsCollectionView?.dataSource = self
        itemsCollectionView?.delegate = self
        itemsCollectionView?.registerNib(DisplayCharacterItemCollectionViewCell.self)
    }
    
    private func bind(to viewModel: DisplayCharacterItemsViewModel) {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: DisplayCharacterItemsViewModel) {
        viewModel.didLoad()
    }
    
    private func render(_ viewModel: DisplayCharacterItemsViewModel) {
        viewModel.items
            .subscribe(onNext: { [weak self] items in
                self?.items = items
                self?.itemCountPerRow = self?.items.first?.type == .body ? 2 : 3
                self?.itemsCollectionView?.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private var items: [CharacterItem] = []
    private var itemCountPerRow = 3
    
    @IBOutlet private weak var itemsCollectionView: UICollectionView?
}

extension DisplayCharacterItemsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(DisplayCharacterItemCollectionViewCell.self, for: indexPath),
              let item = items[safe: indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.configure(with: item)
        return cell
    }
    
}

extension DisplayCharacterItemsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tapItem(at: indexPath.row)
    }
    
}

extension DisplayCharacterItemsViewController: UICollectionViewDelegateFlowLayout {
    
    var itemSpacing: CGFloat { 16 }
    var lineSpacing: CGFloat { 16 }
    var sectionInsets: UIEdgeInsets { UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24) }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let itemCountPerRow = CGFloat(itemCountPerRow)
        let countOfSpace = itemCountPerRow - 1
        let rowWidth = screenWidth - (sectionInsets.left + sectionInsets.right)
        let itemSide = (rowWidth - (itemSpacing * countOfSpace)) / itemCountPerRow
        return CGSize(width: itemSide.rounded(.down), height: itemSide.rounded(.down))
    }
}
