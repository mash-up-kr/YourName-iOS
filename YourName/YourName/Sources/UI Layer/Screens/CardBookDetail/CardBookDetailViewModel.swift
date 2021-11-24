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
    let friendCardsForDisplay = BehaviorRelay<[FriendCardCellViewModel]>(value: [])
    let isEditing = BehaviorRelay<Bool>(value: false)
    let shouldClose = PublishRelay<Void>()
    let selectedIDs = BehaviorRelay<Set<String>>(value: [])
    
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
                self.friendCards.accept(cards)
                self.friendCardsForDisplay.accept(cards.compactMap(self.transform(card:)))
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapMore() {
        
    }
    
    func tapBack() {
        shouldClose.accept(Void())
    }
    
    func tapEdit() {
        guard self.isEditing.value == false else { return }
        
        self.isEditing.accept(true)
        let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map { $0.with { $0.isEditing = true } }
        self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
    }
    
    func tapCheck(id: String) {
        var cellViewModels = self.friendCardsForDisplay.value
        guard let selectedIndex = cellViewModels.firstIndex(where: { $0.id == id }) else { return }
        guard var cellViewModel = cellViewModels[safe: selectedIndex]               else { return }
        
        cellViewModel.isChecked.toggle()
        cellViewModels[selectedIndex] = cellViewModel
        self.friendCardsForDisplay.accept(cellViewModels)
    }
    
    func tapCheck(at index: Int) {
        guard self.isEditing.value else { return }
        guard var selectedCardForDisplay = self.friendCardsForDisplay.value[safe: index] else { return }
        
        self.checkedCardIndice.toggle(index)
        selectedCardForDisplay.isChecked.toggle()
        
        let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.with { $0[index] = selectedCardForDisplay }
        self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
    }
    
    func tapRemove() {
        guard self.isEditing.value else { return }
        
        guard self.checkedCardIndice.isNotEmpty else {
            self.isEditing.accept(false)
            let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map { $0.with { $0.isEditing = false } }
            self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
            return
        }
        
        let checkedCardIDs = self.checkedCardIndice.compactMap { index in self.friendCards.value[safe: index]?.id }
        self.cardRepository.remove(cardIDs: checkedCardIDs)
            .subscribe(onNext: { [weak self] deletedCardIDs in
                guard let self = self           else { return }
                guard deletedCardIDs.isNotEmpty else { return }

                let deletedCardIDSet = Set(deletedCardIDs)
                let updatedCards = self.friendCards.value.with { cards in
                    cards.removeAll(where: { deletedCardIDSet.contains($0.id ?? .empty) })
                }
                self.isEditing.accept(false)
                self.friendCards.accept(updatedCards)
                let updatedFriendCardsForDisplay = updatedCards.compactMap(self.transform(card:)).map { $0.with { $0.isEditing = false } }
                self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
                
                
                self.checkedCardIndice.removeAll()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func transform(card: NameCard) -> FriendCardCellViewModel {
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
    
    private let friendCards = BehaviorRelay<[NameCard]>(value: [])
    private var checkedCardIndice = Set<Int>()
    private let disposeBag = DisposeBag()
    
    private let cardBookID: String
    private let cardRepository: CardRepository
}
