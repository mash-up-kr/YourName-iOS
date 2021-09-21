//
//  MyCardListViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import RxSwift

enum MyCardPath: Equatable {
    case cardDetail(cardID: String)
}

typealias MyCardListNavigation = Navigation<MyCardPath>

final class MyCardListViewModel {
    
    let navigation = PublishSubject<MyCardListNavigation>()
    
    init(myCardRepository: MyCardRepository) {
        self.myCardRepository = myCardRepository
    }
    
    func load() {
        #warning("⚠️ TODO: 레포지토리로부터 로드한 후, 화면에 맞게 포맷팅하는 로직 추가하고 테스트해야합니다.") // Booung
        _ = myCardRepository.fetchList()
    }
    
    func tapCard(at index: Int) {
        
    }
    
    private let myCardRepository: MyCardRepository
    
    private let disposeBag = DisposeBag()
}
