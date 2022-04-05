//
//  CreateCardBookViewModelType.swift
//  MEETU
//
//  Created by Seori on 2022/04/06.
//

import Foundation
import RxSwift
import RxRelay

protocol CreateCardBookViewModelType: AnyObject {
    var colorRepository: ColorRepository { get }
    var cardBookRepository: CardBookRepository { get }
    var disposeBag: DisposeBag { get }
    var cardBookCoverBgColors: BehaviorRelay<[CardBookCoverBackgroundColorCell.Item]> { get }
    var shouldNavigationPop: PublishRelay<Void> { get }
    var cardBookName: BehaviorRelay<String> { get }
    var cardBookDesc: BehaviorRelay<String> { get }
    var cardBookBgColor: BehaviorRelay<Int> { get }
    var confirmButtonEnabled: PublishRelay<Bool> { get }
    
    
    func fetchColors()
    func bgIsSelected(at index: Int)
    func didTapConfrim()
    func numberOfItemsInSection() -> Int
    func cellForItem(at indexPath: IndexPath) -> CardBookCoverBackgroundColorCell.Item?
    func cardBookName(text: String)
    func cardBookDesc(text: String)
    func fetch()
    func bind()
}

extension CreateCardBookViewModelType {
    
    typealias CardBookBgColorCellItem = CardBookCoverBackgroundColorCell.Item
    
    func fetchColors() {
        self.colorRepository.fetchAll()
            .map { colors -> [CardBookBgColorCellItem] in
                return colors.enumerated().map { index, color in
                    let isLocked: Bool
                    switch color.status {
                    case .locked:
                        isLocked = true
                    default:
                        isLocked = false
                    }
                    
                    let bgColor: [UIColor]
                    switch color.colorSource {
                    case .monotone(let color):
                        bgColor = [color]
                    case .gradient(let colors):
                        bgColor = colors
                    }
                    return CardBookBgColorCellItem(
                        id: color.id,
                        isLocked: isLocked,
                        bgColor: bgColor,
                        isSelected: index == 0
                    )
                }
            }
            .bind(to: self.cardBookCoverBgColors)
            .disposed(by: self.disposeBag)
    }
    
    func bgIsSelected(at index: Int) {
        if self.cardBookCoverBgColors.value[safe: index]?.isLocked ?? true { return }
        
        self.cardBookBgColor.accept(index)
        let items = self.cardBookCoverBgColors.value.enumerated().map { _index, colorItem -> CardBookBgColorCellItem in
            var _colorItem = colorItem
            _colorItem.update(isSelected: _index == index)
            return _colorItem
        }
        self.cardBookCoverBgColors.accept(items)
    }
    
    func cardBookDesc(text: String) {
        self.cardBookDesc.accept(text)
    }
    
    func cardBookName(text: String) {
        self.cardBookName.accept(text)
    }
    
    func numberOfItemsInSection() -> Int {
        return self.cardBookCoverBgColors.value.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> CardBookBgColorCellItem? {
        return self.cardBookCoverBgColors.value[safe: indexPath.item]
    }
    
    func bind() {
        self.cardBookName
            .filter { $0.count >= 1 }
            .map { name in
                if name.count >= 1 { return true }
                else { return false}
            }
            .bind(to: self.confirmButtonEnabled)
            .disposed(by: self.disposeBag)
    }
}
