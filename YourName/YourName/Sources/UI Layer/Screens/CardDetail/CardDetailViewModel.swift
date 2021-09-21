//
//  CardDetailViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation

final class CardDetailViewModel {
    init(cardID: String) {
        self.cardID = cardID
    }
    
    private let cardID: String
}
