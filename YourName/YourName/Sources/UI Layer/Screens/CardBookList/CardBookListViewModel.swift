//
//  CardBookViewModel.swift
//  MEETU
//
//  Created by USER on 2021/10/28.
//

import Foundation
import RxRelay
import RxSwift


enum CardBookListDestination: Equatable {
    case addFriend
    case addCardBook
    case cardBookDetail(cardBookID: CardBookID?, cardBookTitle: String?)
}

typealias CardBookListNavigation = Navigation<CardBookListDestination>


final class CardBookListViewModel {
    
    let navigation = PublishRelay<CardBookListNavigation>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let cardBooks = BehaviorRelay<[CardBook]>(value: [])
    
    init(cardBookRepository: CardBookRepository) {
        self.cardBookRepository = cardBookRepository
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        cardBookRepository.fetchAll()
            .subscribe(onNext: { [weak self] cardBooks in
                self?.isLoading.accept(false)
                self?.cardBooks.accept(cardBooks)
            })
            .disposed(by: self.disposeBag)
    }
    
    func refreshCardBooks() {
        self.isLoading.accept(true)
        cardBookRepository.fetchAll()
            .subscribe(onNext: { [weak self] cardBooks in
                self?.isLoading.accept(false)
                self?.cardBooks.accept(cardBooks)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapAddFriend() {
        navigation.accept(.push(.addFriend))
    }
    
    func tapAddCardBook() {
        navigation.accept(.push(.addCardBook))
    }
    
    func selectCardBook(at indexPath: IndexPath) {
        guard let selectedCardBook = self.cardBooks.value[safe: indexPath.row] else { return }
        
        navigation.accept(.push(.cardBookDetail(cardBookID: selectedCardBook.id,
                                                cardBookTitle: selectedCardBook.title)))
    }
    
    private func transform() {
        
    }
    
    private let disposeBag = DisposeBag()
    
    private let cardBookRepository: CardBookRepository
    
}
