//
//  MyCardListViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import RxRelay
import RxSwift

enum MyCardListDestination: Equatable {
    case cardCreation
    case cardDetail(cardID: Int)
}

typealias MyCardListNavigation = Navigation<MyCardListDestination>

final class MyCardListViewModel {
    
    typealias MyCard = CardFrontView.Item
    
    let navigation = PublishRelay<MyCardListNavigation>()
    private let myCardList = BehaviorRelay<[MyCard]>(value: [])
    private let myCardRepository: MyCardRepository
    private let disposeBag = DisposeBag()
    
    init(myCardRepository: MyCardRepository) {
        self.myCardRepository = myCardRepository
    }
    
    deinit {
        print("💀 \(String(describing: self))")
    }
    
    // MARK: - Methods
    
    func load() {
        
        myCardRepository.fetchMyFrontCard()
            .bind(to: myCardList)
            .disposed(by: disposeBag)
    }
    
    func tapCardCreation() {
        navigation.accept(.present(.cardCreation))
    }
    
    func tapCard(at index: Int) {
        guard let selectedCard = myCardList.value[safe: index] else { return }
        guard let selectedCardID = selectedCard.id else { return }
        navigation.accept(.push(.cardDetail(cardID: selectedCardID)))
    }
}

extension MyCardListViewModel {
    var myCardIsEmpty: Bool {
        return self.myCardList.value.isEmpty
    }
    func cellForItem(at row: Int) -> CardFrontView.Item? {
        
        return self.myCardList.value[safe: row]?
    }
    var numberOfMyCards: Int {
        return self.myCardList.value.count
    }
}
