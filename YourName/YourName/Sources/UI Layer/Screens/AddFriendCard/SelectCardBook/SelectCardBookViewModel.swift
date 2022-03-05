//
//  SelectCardBookViewModel.swift
//  MEETU
//
//  Created by seori on 2021/11/13.
//

import UIKit
import RxSwift
import RxRelay

enum SelectCardBookDestination: Equatable {
    case cardDetail(uniqueCode: UniqueCode, cardId: Identifier)
}

typealias SelectCardBookNavigation = Navigation<SelectCardBookDestination>

final class SelectCardBookViewModel {
    
    typealias Item = SelectCardBookCollectionViewCell.Item
    
    // output
    let shouldPopViewController: PublishRelay<Void>
    let isEnabledCompleteButton: BehaviorRelay<Bool>
    let toastView: PublishRelay<ToastView>
    let reloadData: PublishRelay<Void>
    let reloadItem: PublishRelay<IndexPath>
    let navigation: PublishRelay<SelectCardBookNavigation>

    private let items: BehaviorRelay<[Item]>
    private let disposeBag: DisposeBag
    private let friendCardUniqueCode: UniqueCode
    
    // repository
    private let questRepository: QuestRepository
    private let cardBookRepository: CardBookRepository
    private let addFriendCardRepository: AddFriendCardRepository
    
    init(cardBookRepository: CardBookRepository,
         addFriendCardRepository: AddFriendCardRepository,
         questRepository: QuestRepository,
         friendCardUniqueCode: UniqueCode) {
        self.cardBookRepository = cardBookRepository
        self.addFriendCardRepository = addFriendCardRepository
        self.questRepository = questRepository
        self.items = .init(value: [])
        self.reloadData = .init()
        self.reloadItem = .init()
        self.disposeBag = .init()
        self.toastView = .init()
        self.isEnabledCompleteButton = .init(value: false)
        
        self.navigation = .init()
        self.friendCardUniqueCode = friendCardUniqueCode
        self.shouldPopViewController = .init()
        
        self.bind()
        self.fetchCardBooks(self.cardBookRepository)
    }

    func fetchCardBooks(_ repository: CardBookRepository) {
        repository.fetchAll()
            .map { cardBooks in
                var _cardBooks = cardBooks.reversed().map { cardBook -> SelectCardBookCollectionViewCell.Item in
                    SelectCardBookCollectionViewCell.Item(id: cardBook.id ?? "",
                                                          name: cardBook.title ?? "",
                                                          count: cardBook.count ?? 0,
                                                          bgColorHexString: cardBook.backgroundColor ?? [])
                }
                _cardBooks.removeFirst()
                return _cardBooks
            }
            .bind(to: self.items)
            .disposed(by: self.disposeBag)
    }

    func numberOfItems(section: Int) -> Int {
        items.value.count
    }
    func cellForItem(at indexPath: IndexPath) -> Item? {
        self.items.value[safe: indexPath.row]
    }
    func didSelectCardBook(at indexPath: IndexPath) {
        var _items = self.items.value
        _items[indexPath.item].isChecked.toggle()
        self.items.accept(_items)
        self.reloadItem.accept(indexPath)
    }
    
    func bind() {
        self.items
            .map { items -> Bool in
                var value: Bool = false
                items.forEach { item in
                    if item.isChecked {
                        value = true
                        return
                    }
                }
                return value
            }
            .bind(onNext: { [weak self] value in
                self?.isEnabledCompleteButton.accept(value)
            })
            .disposed(by: self.disposeBag)
    }
    func didTapCompleteButton() {
        
        var cardBooksIds: [String] = []
        self.items.value.forEach { item in
            if item.isChecked { cardBooksIds.append(item.id) }
        }
        
        self.addFriendCardRepository.addFriendCard(at: cardBooksIds, uniqueCode: friendCardUniqueCode)
            .catchError { error in
                print(error)
                return .empty()
            }
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.questRepository.updateQuest(.addFriendNameCard, to: .waitingDone)
                    .asObservable()
                    .mapToVoid()
            }
            .bind(onNext: { [weak self] _ in
                self?.toastView.accept(ToastView(text: "성공적으로 추가됐츄!"))
                self?.shouldPopViewController.accept(())
                NotificationCenter.default.post(name: .addFriendCard, object: nil)
            })
            .disposed(by: self.disposeBag)
        
    }
}
