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
    case cardDetail(cardId: Identifier, uniqueCode: UniqueCode)
    case cardBookMore(cardBookId: CardBookID, cardBookName: String)
}

typealias CardBookDetailNavigation = Navigation<CardBookDetailDestination>

final class CardBookDetailViewModel {
    
    let navigation = PublishRelay<CardBookDetailNavigation>()
    let shouldShowRemoveReconfirmAlert = PublishRelay<AlertItem>()
    let askStopEditingAlert = PublishRelay<AlertItem>()
    let cardBookTitle = BehaviorRelay<String>(value: .empty)
    let friendCardsForDisplay = BehaviorRelay<[FriendCardCellViewModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isEditing = BehaviorRelay<Bool>(value: false)
    let isAllCardBook = BehaviorRelay<Bool>(value: false)
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
        
        self.isAllCardBook.accept(cardBookID == nil)
        self.cardBookTitle.accept(self._cardBookTitle)
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        let friendCards: Observable<[NameCard]> = { [weak self] in
            guard let self = self else { return .empty() }
            if let cardBookID = self.cardBookID { return self.cardRepository.fetchCards(cardBookID: cardBookID) }
            else { return self.cardRepository.fetchAll() }
        }()
        friendCards
            .subscribe(onNext: { [weak self] cards in
            guard let self = self else { return }
            self.cardBookTitle.accept("\(self._cardBookTitle) (\(cards.count))")
            self.friendCards.accept(cards)
            self.friendCardsForDisplay.accept(cards.compactMap(self.transform(card:)))
            self.isLoading.accept(false)
        })
        .disposed(by: self.disposeBag)
    }
    
    func tapMore() {
        self.navigation.accept(.show(.cardBookMore(cardBookId: self.cardBookID ?? "", cardBookName: self._cardBookTitle)))
    }
    
    func tapBack() {
        shouldClose.accept(Void())
    }
    
    func tapCard(at index: Int) {
        if self.isEditing.value { self.tapCheck(at: index) }
        else { self.navigateToCardDetail(at: index) }
    }
    
    private func navigateToCardDetail(at index: Int) {
        guard let card = friendCards.value[safe: index] else { return }
        guard let cardId = card.id else { return }
        guard let uniqueCode = card.uniqueCode else { return }
        self.navigation.accept(.push(.cardDetail(cardId: cardId, uniqueCode: uniqueCode)))
    }
    
    func tapEdit() {
        
    }
    
    func tapRemoveButton() {
        guard self.friendCards.value.isEmpty == false else { return }
        if self.checkedCardIndice.value.isEmpty && !self.isEditing.value {
            self.setUpCards(isEditing: true)
        } else {
            self.checkedCardIndice.accept(.init())
            self.setUpCards(isEditing: false)
        }
    }
    
    private func setUpCards(isEditing: Bool) {
        self.isEditing.accept(isEditing)
        let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map { $0.with {
            $0.isEditing = isEditing
            $0.isChecked = false
        } }
        self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
    }
    
    private func tapCheck(at index: Int) {
        guard self.isEditing.value else { return }
        guard var selectedCardForDisplay = self.friendCardsForDisplay.value[safe: index] else { return }

        var item = self.checkedCardIndice.value
        item.toggle(index)
        self.checkedCardIndice.accept(item)
        selectedCardForDisplay.isChecked.toggle()

        let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.with { $0[index] = selectedCardForDisplay }
        self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
    }
    
    func tapRemove() {
        guard self.friendCards.value.isEmpty == false,
              self.checkedCardIndice.value.isNotEmpty else {
                  self.setUpCards(isEditing: false)
            return
        }
        let okAction = { [weak self] in
            guard let self = self else { return }
            self.tapRemoveConfirm()
        }
        let cancelAction = { [weak self] in
            guard let self = self else { return }
            self.tapRemoveCancel()
        }
        let alert = AlertItem(title: "정말 삭제하시겠츄?",
                              messages: "삭제한 미츄와 도감은 복구할 수 없어요.",
                              image: UIImage(named: "meetu_delete")!,
                              emphasisAction: .init(title: "삭제하기", action: okAction),
                              defaultAction: .init(title: "삭제안할래요", action: cancelAction))
        
        self.shouldShowRemoveReconfirmAlert.accept(alert)
    }
    
    private func tapRemoveConfirm() {
        guard self.isEditing.value             else { return }
        
        guard self.checkedCardIndice.value.isNotEmpty else {
            self.isEditing.accept(false)
            let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map { $0.with { $0.isEditing = false } }
            self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
            return
        }
        
        let checkedCardIDs = self.checkedCardIndice.value.compactMap { index in self.friendCards.value[safe: index]?.idForDelete }
        
        self.cardRepository.remove(cardIDs: checkedCardIDs, on: cardBookID ?? "all").subscribe(onNext: { [weak self] _ in //deletedCardIDs in
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
                
            self.checkedCardIndice.accept(.init())
            
            NotificationCenter.default.post(name: .friendCardDidDelete, object: nil)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func tapRemoveCancel() {
        self.isEditing.accept(false)
        self.checkedCardIndice.accept(.init())
        let updatedFriendCardsForDisplay = self.friendCardsForDisplay.value.map {
            $0.with {
                $0.isEditing = false
                $0.isChecked = false
            }
        }
        self.friendCardsForDisplay.accept(updatedFriendCardsForDisplay)
    }
    
    private func transform(card: NameCard) -> FriendCardCellViewModel {
        let colors = card.bgColors?.compactMap { UIColor(hexString: $0) } ?? [.gray]
        
        return FriendCardCellViewModel(
            id: card.id,
            name: card.name,
            role: card.role,
            bgColor: colors.count > 1 ? .gradient(colors) : .monotone(colors.first ?? .gray),
            profileImageUrl: URL(string: card.profileURL ?? .empty),
            isEditing: false,
            isChecked: false
        )
    }
    
    private let friendCards = BehaviorRelay<[NameCard]>(value: [])
    let checkedCardIndice = BehaviorRelay<Set<Int>>(value: .init())
    private let disposeBag = DisposeBag()
    
    private let cardBookID: CardBookID?
    private let _cardBookTitle: String
    private let cardRepository: CardRepository
}
