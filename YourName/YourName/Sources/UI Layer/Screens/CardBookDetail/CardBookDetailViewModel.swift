//
//  CardBookViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import Foundation
import RxSwift
import RxRelay

enum CardBookDetailDestination: Equatable {
}

typealias CardBookDetailNavigation = Navigation<CardBookDetailDestination>

final class CardBookDetailViewModel {
    
    let navigation = PublishRelay<CardBookDetailNavigation>()
    let cardBookTitle = PublishRelay<String>()
    let cellViewModels = BehaviorRelay<[FriendCardCellViewModel]>(value: [])
    let isEditing = BehaviorRelay<Bool>(value: false)
    let shouldClose = PublishRelay<Void>()
    let selectedIDs = BehaviorRelay<Set<String>>(value: [])
    
    let cards = BehaviorRelay<[Card]>(value: [])
    
    init(
        cardBookID: String,
        cardRepository: CardRepository
    ) {
        self.cardBookID = cardBookID
        self.cardRepository = cardRepository
    }
    
    func didLoad() {
        self.cardRepository.fetchCards(cardBookID: self.cardBookID)
            .subscribe(onNext: { [weak self] cards in
                guard let self = self else { return }
                self.cards.accept(cards)
                self.cellViewModels.accept(cards.compactMap(self.transform(card:)))
            })
            .disposed(by: self.disposeBag)
    }
    
    private func transform(card: Card) -> FriendCardCellViewModel {
        let colors = card.bgColors?.compactMap { UIColor(hexString: $0) }
        
        return FriendCardCellViewModel(
            id: card.id,
            name: card.name,
            role: card.role,
            bgColor: .monotone(colors?.first ?? .white),
            isEditing: false,
            isChecked: false
        )
    }
    
    func tapMore() {
        
    }
    
    func tapBack() {
        shouldClose.accept(Void())
    }
    
    func tapEdit() {
        var isEditing = self.isEditing.value
        defer {
            isEditing.toggle()
            self.isEditing.accept(isEditing)
        }
        if self.isEditing.value {
//            cellViewModels
        } else {
            
        }
    }
    
    func tapCheck(id: String) {
        var cellViewModels = self.cellViewModels.value
        guard let selectedIndex = cellViewModels.firstIndex(where: { $0.id == id }) else { return }
        guard var cellViewModel = cellViewModels[safe: selectedIndex]               else { return }
        
        cellViewModel.isChecked.toggle()
        cellViewModels[selectedIndex] = cellViewModel
        self.cellViewModels.accept(cellViewModels)
    }
    
    private let disposeBag = DisposeBag()
    
    private let cardBookID: String
    private let cardRepository: CardRepository
}
