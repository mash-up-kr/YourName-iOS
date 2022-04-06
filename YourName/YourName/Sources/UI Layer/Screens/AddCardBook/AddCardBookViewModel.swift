//
//  AddCardBookViewModel.swift
//  MEETU
//
//  Created by Seori on 2022/02/08.
//

import Foundation
import RxSwift
import RxRelay

final class AddCardBookViewModel: CreateCardBookViewModelType {
    
    typealias CardBookBgColorCellItem = CardBookCoverBackgroundColorCell.Item
    
    var colorRepository: ColorRepository
    var cardBookRepository: CardBookRepository
    var disposeBag = DisposeBag()
    var cardBookCoverBgColors = BehaviorRelay<[CardBookBgColorCellItem]>(value: [])
    var shouldNavigationPop = PublishRelay<Void>()
    var cardBookName = BehaviorRelay<String>(value: "")
    var cardBookDesc = BehaviorRelay<String>(value: "")
    var cardBookBgColor = BehaviorRelay<Int>(value: 0)
    var confirmButtonEnabled = PublishRelay<Bool>()
    
    init(
        colorRepository: ColorRepository,
        cardBookRepository: CardBookRepository
    ) {
        self.colorRepository = colorRepository
        self.cardBookRepository = cardBookRepository
        self.fetchColors()
    }
    
    func fetch() {
        self.fetchColors()
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
    
}
