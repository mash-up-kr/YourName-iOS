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
    
    let cardBookTitle = PublishRelay<String>()
    let cards = BehaviorRelay<[Card]>(value: [])
    let navigation = PublishRelay<CardBookDetailNavigation>()
    let shouldClose = PublishRelay<Void>()
    
    init(
        cardBookID: String,
        cardRepository: CardRepository
    ) {
        self.cardBookID = cardBookID
        self.cardRepository = cardRepository
    }
    
    func didLoad() {
        cardRepository.fetchCards(cardBookID: self.cardBookID)
            .subscribe(onNext: { [weak self] cards in
                self?.cards.accept(cards)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapMore() {
        
    }
    
    func tapBack() {
        shouldClose.accept(Void())
    }
    
    private let disposeBag = DisposeBag()
    
    private let cardBookID: String
    private let cardRepository: CardRepository
}
