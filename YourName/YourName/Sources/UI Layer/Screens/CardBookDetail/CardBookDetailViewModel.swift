//
//  CardBookViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import Foundation
import RxRelay

enum CardBookDetailDestination: Equatable {
}

typealias CardBookDetailNavigation = Navigation<CardBookDetailDestination>

final class CardBookDetailViewModel {
    
    let cardBookTitle = PublishRelay<String>()
    let cards = BehaviorRelay<[Card]>(value: [])
    let navigation = PublishRelay<CardBookDetailNavigation>()
    
    init(cardBookRepository: CardBookRepository) {
        
    }
    
    func tapMore() {
        
    }
    
    func tapBack() {
        
    }
}
