//
//  CardDetailViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation
import RxSwift
import RxCocoa

enum CardDetailDestination: Equatable {
    case cardDetailMore(cardID: Identifier)
}

typealias CardDetailNavigation = Navigation<CardDetailDestination>

final class CardDetailViewModel {
    
    let isLoading = PublishRelay<Bool>()
    let navigation = PublishRelay<CardDetailNavigation>()
    private let disposeBag = DisposeBag()
    private let cardID: Identifier
    
    
    // MARK: - LifeCycle
    init(cardID: Identifier) {
        self.cardID = cardID
    }
     
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    // MARK: - Methods
    
    func didTapMore() {
        navigation.accept(.present(.cardDetailMore(cardID: self.cardID)))
    }
}
