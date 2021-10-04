//
//  CardBookViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import Foundation
import RxRelay

enum CardBookDestination: Equatable {
    case search
}

typealias CardBookNavigation = Navigation<CardBookDestination>

final class CardBookViewModel {
    
    let navigation = PublishRelay<CardBookNavigation>()
    
    func tapSearchButton() {
        navigation.accept(.present(.search))
    }
    
    init(cardBookRepository: CardBookRepository) {
        
    }
}
