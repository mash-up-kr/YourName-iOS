//
//  CardBookViewModel.swift
//  MEETU
//
//  Created by USER on 2021/10/28.
//

import Foundation
import RxRelay
import RxSwift


enum CardBookDestination: Equatable {
    case addFriend
    case addCardBook
    case cardBookDetail(cardBookID: String)
}

typealias CardBookNavigation = Navigation<CardBookDestination>


final class CardBookViewModel {
    
    let navigation = PublishRelay<CardBookNavigation>()
    
    let cardBooks = BehaviorRelay<[CardBook]>(value: [])
    
    init(cardBookRepository: CardBookRepository) {
        self.cardBookRepository = cardBookRepository
    }
    
    func didLoad() {
        cardBookRepository.fetchAll()
            .subscribe(onNext: { [weak self] cardBooks in
                self?.cardBooks.accept(cardBooks)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapAddFriend() {
        
    }
    
    func tapAddCardBook() {
        navigation.accept(.push(.addCardBook))
    }
    
    func selectCardBook(at indexPath: IndexPath) {
        guard let selectedCardBook = self.cardBooks.value[safe: indexPath.row] else { return }
        guard let cardBookID = selectedCardBook.id else{ return }
        
        navigation.accept(.push(.cardBookDetail(cardBookID: cardBookID)))
    }
    
    private func transform() {
        
    }
    
    private let disposeBag = DisposeBag()
    
    private let cardBookRepository: CardBookRepository
    
}
