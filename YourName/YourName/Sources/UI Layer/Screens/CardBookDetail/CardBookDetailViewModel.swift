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
    case cardDetail(id: Identifier)
}

typealias CardBookDetailNavigation = Navigation<CardBookDetailDestination>

final class CardBookDetailViewModel {
    
    let navigation = PublishRelay<CardBookDetailNavigation>()
    let shouldShowRemoveReconfirmAlert = PublishRelay<Void>()
    let cardBookTitle = BehaviorRelay<String>(value: .empty)
    let friendCardsForDisplay = BehaviorRelay<[FriendCardCellViewModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isEditing = BehaviorRelay<Bool>(value: false)
    let isEmpty = BehaviorRelay<Bool>(value: true)
    let shouldClose = PublishRelay<Void>()
    let selectedIDs = BehaviorRelay<Set<String>>(value: [])
    
    init(
        cardBookID: CardBookID?,
        cardBookTitle: String?,
        cardRepository: CardRepository
    ) {
        self.cardBookID = cardBookID
        self._cardBookTitle = cardBookTitle ?? .empty
        self.cardRepository = cardRepository
        
        self.cardBookTitle.accept(self._cardBookTitle)
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        let friendCards: Observable<[NameCard]> = { [weak self] in
            guard let self = self else { return .empty() }
            if let cardBookID = self.cardBookID { return self.cardRepository.fetchCards(cardBookID: cardBookID) }
            else { return self.cardRepository.fetchAll() }
        }()
        friendCards.subscribe(onNext: { [weak self] cards in
            guard let self = self else { return }
            self.cardBookTitle.accept("\(self._cardBookTitle)(\(cards.count))")
            self.friendCards.accept(cards)
            self.friendCardsForDisplay.accept(cards.compactMap(self.transform(card:)))
            self.isLoading.accept(false)
            self.isEmpty.accept(cards.isEmpty)
        })
        .disposed(by: self.disposeBag)
    }
    
    func tapMore() {
        
    }
    
    func tapBack() {
        shouldClose.accept(Void())
    }
    
    func tapEdit() {
        guard self.isEmpty.value == false   else { return }
        guard self.isEditing.value == false else { return }
        
        self.isEditing.accept(true)
        let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map { $0.with { $0.isEditing = true } }
        self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
    }
    
    func tapCheck(id: NameCardID) {
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
        guard self.isEmpty.value == false else { return }
        
        self.shouldShowRemoveReconfirmAlert.accept(Void())
    }
    
    func tapRemoveConfirm() {
        guard self.isEditing.value             else { return }
        guard let cardBookID = self.cardBookID else { return }
        
        guard self.checkedCardIndice.isNotEmpty else {
            self.isEditing.accept(false)
            let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map { $0.with { $0.isEditing = false } }
            self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
            return
        }
        
        let checkedCardIDs = self.checkedCardIndice.compactMap { index in self.friendCards.value[safe: index]?.id }
        self.cardRepository.remove(cardIDs: checkedCardIDs, on: cardBookID)
            .subscribe(onNext: { [weak self] _ in //deletedCardIDs in
                guard let self = self           else { return }
                guard checkedCardIDs.isNotEmpty else { return }

                let deletedCardIDSet = Set(checkedCardIDs)
                let updatedCards = self.friendCards.value.with { cards in
                    cards.removeAll(where: { card in
                        guard let id = card.id else { return false }
                        return deletedCardIDSet.contains(id)
                    })
                }
                self.isEditing.accept(false)
                self.friendCards.accept(updatedCards)
                let updatedFriendCardsForDisplay = updatedCards.compactMap(self.transform(card:)).map { $0.with { $0.isEditing = false } }
                self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
                
                self.checkedCardIndice.removeAll()
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapRemoveCancel() {
        self.isEditing.accept(false)
        self.checkedCardIndice.removeAll()
        let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map {
            $0.with {
                $0.isEditing = false
                $0.isChecked = false
            }
        }
        self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
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
    
    private let cardBookID: CardBookID?
    private let _cardBookTitle: String
    private let cardRepository: CardRepository
}
