//
//  MyCardListViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import RxRelay
import RxSwift

enum MyCardListDesitination: Equatable {
    case cardCreation
    case cardDetail(cardID: String)
}

typealias MyCardListNavigation = Navigation<MyCardListDesitination>

final class MyCardListViewModel {
    
    let navigation = PublishRelay<MyCardListNavigation>()
    
    init(myCardRepository: MyCardRepository) {
        self.myCardRepository = myCardRepository
    }
    
    func load() {
        #warning("⚠️ TODO: 레포지토리로부터 로드한 후, 화면에 맞게 포맷팅하는 로직 추가하고 테스트해야합니다.") // Booung
        myCardRepository.fetchList()
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
    
    private let myCardList = BehaviorRelay<[NameCard]>(value: [])
    private let myCardRepository: MyCardRepository
    private let disposeBag = DisposeBag()
}
