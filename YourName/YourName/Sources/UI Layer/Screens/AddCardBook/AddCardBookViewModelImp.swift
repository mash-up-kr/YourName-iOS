//
//  AddCardBookViewModelImp.swift
//  MEETU
//
//  Created by Seori on 2022/02/08.
//

import Foundation
import RxSwift
import RxRelay

final class AddCardBookViewModelImp: AddCardBookViewModel {
    
    typealias CardBookBgColorCellItem = CardBookCoverBackgroundColorCell.Item
    typealias Mode = AddCardBookDependencyContainer.Mode
    
    private let colorRepository: ColorRepository
    private let cardBookRepository: CardBookRepository
    private var mode: Mode
    
    init(
        colorRepository: ColorRepository,
        cardBookRepository: CardBookRepository,
        mode: Mode
    ) {
        self.colorRepository = colorRepository
        self.cardBookRepository = cardBookRepository
        self.mode = mode
    }
    
    private let disposeBag = DisposeBag()
    var cardBookCoverBgColors = BehaviorRelay<[CardBookBgColorCellItem]>(value: [])
    var shouldNavigationPop = PublishRelay<Void>()
    private let cardBookName = BehaviorRelay<String>(value: "")
    private let cardBookDesc = BehaviorRelay<String>(value: "")
    private let cardBookBgColor = BehaviorRelay<Int>(value: 0)
    
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
    
    func bgIsSelected(at indexPath: IndexPath) {
        if self.cardBookCoverBgColors.value[safe: indexPath.item]?.isLocked ?? true { return }
        
        self.cardBookBgColor.accept(indexPath.item)
        let items = self.cardBookCoverBgColors.value.enumerated().map { index, colorItem -> CardBookBgColorCellItem in
            var _colorItem = colorItem
            _colorItem.update(isSelected: index == indexPath.item)
            return _colorItem
        }
        self.cardBookCoverBgColors.accept(items)
    }
    
    func didTapConfrim() {
        let bgColorId = self.cardBookCoverBgColors.value[safe: self.cardBookBgColor.value]?.id ?? "1"

        self.cardBookRepository.addCardBook(
            name: self.cardBookName.value,
            desc: self.cardBookDesc.value,
            bgColorId: Int(bgColorId) ?? 1
            )
            .catchError { error in
                print(error)
                return .empty()
            }
            .bind(onNext: { [weak self] in
                self?.shouldNavigationPop.accept(())
                NotificationCenter.default.post(name: .cardBookDidChange, object: nil)
            })
            .disposed(by: self.disposeBag)
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
}
