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
    case cardDetailMore(cardID: String)
}

typealias CardDetailNavigation = Navigation<CardDetailDestination>

final class CardDetailViewModel {
    
    private let cardID: String
    private let disposeBag = DisposeBag()
    let isLoading = PublishRelay<Bool>()
    let navigation = PublishRelay<CardDetailNavigation>()
    
    // MARK: - LifeCycle
    init(cardID: String) {
        self.cardID = cardID
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    // MARK: - Methods
    
    func didTapMore() {
        navigation.accept(.show(.cardDetailMore(cardID: self.cardID)))
    }
}
