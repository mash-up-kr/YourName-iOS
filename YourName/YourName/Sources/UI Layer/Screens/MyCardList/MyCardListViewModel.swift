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
    let myCardList = BehaviorRelay<[MyCard]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
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
        self.isLoading.accept(true)
        myCardRepository.fetchMyFrontCard()
            .catchError { error in
                print(error)
                return .empty()
            }
            .bind(onNext: { [weak self] in
                self?.myCardList.accept($0)
                self?.isLoading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapCardCreation() {
        navigation.accept(.present(.cardCreation))
    }
    
    func tapCard(at index: Int) {
        guard let selectedCard = myCardList.value[safe: index] else { return }
        let selectedCardID = selectedCard.id
        navigation.accept(.push(.cardDetail(cardID: selectedCardID)))
    }
}

extension MyCardListViewModel {
    var myCardIsEmpty: Bool {
        return self.myCardList.value.isEmpty
    }
    func cellForItem(at row: Int) -> CardFrontView.Item? {
        return self.myCardList.value[safe: row]
    }
    var numberOfMyCards: Int {
        return self.myCardList.value.count
    }
}
