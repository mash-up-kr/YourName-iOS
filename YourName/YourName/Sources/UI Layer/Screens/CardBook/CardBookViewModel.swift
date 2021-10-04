//
//  CardBookViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import Foundation
import RxRelay

enum CardBookDestination: Equatable {
    case addCard
}

typealias CardBookNavigation = Navigation<CardBookDestination>

final class CardBookViewModel {
    
    let navigation = PublishRelay<CardBookNavigation>()
    
    func tapSearchButton() {
        navigation.accept(.show(.addCard))
    }
    
    init(cardBookRepository: CardBookRepository) {
        
    }
}
