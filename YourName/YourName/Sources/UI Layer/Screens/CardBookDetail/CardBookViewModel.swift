//
//  CardBookViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import Foundation
import RxRelay

enum CardBookDetailDestination: Equatable {
    case addCard
}

typealias CardBookDetailNavigation = Navigation<CardBookDetailDestination>

final class CardBookDetailViewModel {
    
    let navigation = PublishRelay<CardBookDetailNavigation>()
    
    func tapSearchButton() {
        navigation.accept(.push(.addCard))
    }
    
    init(cardBookRepository: CardBookRepository) {
        
    }
}
