//
//  EditCardBookViewModel.swift
//  MEETU
//
//  Created by Seori on 2022/04/06.
//

import Foundation
import RxSwift
import RxRelay

final class EditCardBookViewModel: CreateCardBookViewModelType {
    typealias CardBookBgColorCellItem = CardBookCoverBackgroundColorCell.Item
    
    var cardBookCoverBgColors: BehaviorRelay<[CardBookBgColorCellItem]>
    var shouldNavigationPop: PublishRelay<Void>
    var colorRepository: ColorRepository
    var cardBookRepository: CardBookRepository
    var disposeBag: DisposeBag
    var cardBookName: BehaviorRelay<String>
    var cardBookDesc: BehaviorRelay<String>
    var cardBookBgColor: BehaviorRelay<Int>
    private let cardBookID: CardBookID
    
    init(
        colorRepository: ColorRepository,
        cardBookRepository: CardBookRepository,
        cardBookID: CardBookID
    ) {
        self.colorRepository = colorRepository
        self.cardBookRepository = cardBookRepository
        self.cardBookCoverBgColors = .init(value: [])
        self.shouldNavigationPop = .init()
        self.disposeBag = .init()
        self.cardBookName = .init(value: "")
        self.cardBookDesc = .init(value: "")
        self.cardBookBgColor = .init(value: 0)
        self.cardBookID = cardBookID
    }
    
    func didTapConfrim() {
        
    }
    
    func fetchCardBookInfo(id: CardBookID) {
        
    }
}
