//
//  CardDetailViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class CardDetailViewModel {
    
    init(cardID: Identifier) {
        self.cardID = cardID
    }
    
    private let cardID: Identifier
}
