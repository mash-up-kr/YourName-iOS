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
    
    private var selectedIndex: BehaviorRelay<[IndexPath]>
    let isEnabledCompleteButton: BehaviorRelay<Bool>
    let toastView: PublishRelay<ToastView>
    let items: BehaviorRelay<[SelectCardBookCollectionViewCell.Item]>
    private let disposeBag: DisposeBag
    let navigation: PublishRelay<SelectCardBookNavigation>
    private let cardBookRepository: CardBookRepository
    private let addFriendCardRepository: AddFriendCardRepository
    private let friendCardUniqueCode: UniqueCode
    private let shouldPopViewController: PublishRelay<Void>
    
    init(cardBookRepository: CardBookRepository,
         addFriendCardRepository: AddFriendCardRepository,
         friendCardUniqueCode: UniqueCode) {
        self.cardBookRepository = cardBookRepository
        self.addFriendCardRepository = addFriendCardRepository
        self.items = .init(value: [])
        self.disposeBag = .init()
        self.toastView = .init()
        self.isEnabledCompleteButton = .init(value: false)
        self.selectedIndex = .init(value: [])
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
    func didSelectCardBook(at indexPath: IndexPath, isChecked: Bool) {
        if !isChecked {
            guard let index = selectedIndex.value.firstIndex(of: indexPath) else { return }
            var indexes = selectedIndex.value
            indexes.remove(at: index)
            self.selectedIndex.accept(indexes)
        } else {
            var indexes = selectedIndex.value
            indexes.append(indexPath)
            selectedIndex.accept(indexes)
        }
    }
    
    func bind() {
        self.selectedIndex
            .map { indexes -> Bool in
                if indexes.isEmpty { return false }
                else { return true }
            }
            .bind(onNext: { [weak self] value in
                self?.isEnabledCompleteButton.accept(value)
            })
            .disposed(by: self.disposeBag)
    }
    func didTapCompleteButton() {
        let cardBooksIds = self.selectedIndex.value.compactMap { [weak self] indexPath -> Identifier? in
            return self?.items.value[safe: indexPath.item]?.id
        }
        
        self.addFriendCardRepository.addFriendCard(at: cardBooksIds, uniqueCode: friendCardUniqueCode)
            .catchError { error in
                print(error)
                return .empty()
            }
            .bind(onNext: { [weak self] _ in
                self?.toastView.accept(ToastView(text: "성공적으로 추가됐츄!"))
                self?.shouldPopViewController.accept(())
                NotificationCenter.default.post(name: .addFriendCard, object: nil)
            })
            .disposed(by: self.disposeBag)
        
    }
}
