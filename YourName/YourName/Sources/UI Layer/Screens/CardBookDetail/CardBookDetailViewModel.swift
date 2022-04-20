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
    case cardBookMore(cardBookName: String, cardIsEmpty: Bool)
    case allCardBook(cardBookId: CardBookID)
    case editCardBook(cardBookId: CardBookID)
}

typealias CardBookDetailNavigation = Navigation<CardBookDetailDestination>

final class CardBookDetailViewModel {
    
    enum State {
        case migrate(cardBookId: CardBookID)
        case normal
    }
    
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
    let state = BehaviorRelay<State>(value: .normal)
    let shouldPopViewController = PublishRelay<Void>()
    private let fetchCardInfoTrigger = PublishRelay<Void>()
    private var cardBookName: String = ""
    
    private let cardBookRepository: CardBookRepository
    init(
        cardBookID: CardBookID?,
        cardBookTitle: String?,
        cardRepository: CardRepository,
        cardBookrepository: CardBookRepository,
        state: State = .normal
    ) {
        self.cardBookID = cardBookID
        self.cardRepository = cardRepository
        self.cardBookRepository = cardBookrepository
        
        self.state.accept(state)
        self.isAllCardBook.accept(cardBookID == nil)
        if let _cardBookTitle = cardBookTitle {
            self.cardBookTitle.accept(_cardBookTitle)
            self.cardBookName = _cardBookTitle
        }
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        self.fetchCards()
        self.bind()
        self.fetchCardBookInfo()
    }
    
    func fetchCardBookInfo() {
        if self.cardBookID != nil {
            self.fetchCardInfoTrigger.accept(())
        } else {
            // 전체도감
            self.cardBookTitle.accept("\(self.cardBookTitle.value)")
        }
    }
    
    func fetchCards() {
        let friendCards: Observable<[NameCard]> = { [weak self] in
            guard let self = self else { return .empty() }
            if let cardBookID = self.cardBookID { return self.cardRepository.fetchCards(cardBookID: cardBookID) }
            else { return self.cardRepository.fetchAll() }
        }()
        friendCards
            .withLatestFrom(self.state) { (cards: $0, migrate: $1)}
            .subscribe(onNext: { [weak self] cards, migrate in
            guard let self = self else { return }
            self.cardBookCounts = cards.count
            self.friendCards.accept(cards)
            self.friendCardsForDisplay.accept(cards.compactMap(self.transform(card:)))
            self.isLoading.accept(false)
                
                switch migrate {
                case .migrate:
                    self.tapRemoveButton()
                default: break
                }
        })
        .disposed(by: self.disposeBag)
    }
    
    func tapMore() {
        self.navigation.accept(.show(.cardBookMore(cardBookName: self.cardBookName, cardIsEmpty: self.friendCards.value.isEmpty)))
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
    
    func tapRemoveButton() {
        guard self.friendCards.value.isEmpty == false else { return }
        if self.checkedCardIndice.value.isEmpty {
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
    
    func tapBottomButton() {
        switch self.state.value {
        case .migrate(let cardBookId):
            self.migrateMeetU(at: cardBookId)
        case .normal:
            self.tapRemove()
        }
    }
    
    func migrateMeetU(at cardBookId: CardBookID) {
        let cardIds = self.checkedCardIndice.value.compactMap { index in self.friendCards.value[safe: index]?.id }
        self.cardRepository.migrateCards(at: cardBookId, cards: cardIds)
            .catchError({ error in
                print(error)
                return .empty()
            })
            .bind(onNext: { [weak self] in
                self?.shouldClose.accept(())
                NotificationCenter.default.post(name: .cardBookDidChange, object: nil)
                NotificationCenter.default.post(name: .cardBookDetailDidChange, object: nil)
            })
            .disposed(by: self.disposeBag)
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
    
    private func bind() {
        self.fetchCardInfoTrigger
            .compactMap { [weak self] in
                return self?.cardBookID
            }
            .flatMapLatest { [weak self] id -> Observable<String> in
                guard let self = self else { return .empty() }
                return self.cardBookRepository
                    .fetchCardBook(id: id)
                    .compactMap { $0.name }
            }
            .catchError { error in
                print(error)
                return .empty()
            }
            .map { [weak self] name in
                return "\(name) (\(self?.cardBookCounts ?? 0))"
            }
            .bind(to: self.cardBookTitle)
            .disposed(by: self.disposeBag)
    }
    
    private let friendCards = BehaviorRelay<[NameCard]>(value: [])
    let checkedCardIndice = BehaviorRelay<Set<Int>>(value: .init())
    private var cardBookCounts: Int = 0
    private let disposeBag = DisposeBag()
    
    private let cardBookID: CardBookID?
    private let cardRepository: CardRepository
}


extension CardBookDetailViewModel: CardBookMoreViewListener {
    func didTapAddMember() {
        self.navigation.accept(.push(.allCardBook(cardBookId: self.cardBookID ?? "")))
    }
    
    func didTapDeleteMember() {
        self.tapRemoveButton()
    }
    
    func didTapEditCardBook() {
        guard let cardBookId = self.cardBookID else { return }
        self.navigation.accept(.push(.editCardBook(cardBookId: cardBookId)))
    }
    
    func didTapDeleteCardBook() {
        let okAction = { [weak self] in
            guard let self = self,
                  let cardBookID = self.cardBookID else { return }
            self.cardBookRepository.deleteCardBook(id: cardBookID)
                .bind(onNext: { [weak self] in
                    NotificationCenter.default.post(name: .cardBookListDidChange, object: nil)
                    self?.shouldPopViewController.accept(())
                })
                .disposed(by: self.disposeBag)
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
}
