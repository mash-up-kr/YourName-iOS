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

typealias MyCardCellViewModel = CardFrontView.Item

final class MyCardListViewModel {
    
    let navigation = PublishRelay<MyCardListNavigation>()
    let myCardList = BehaviorRelay<[MyCardCellViewModel]>(value: [])
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
        self.myCardRepository.fetchMyCards()
            .catchError { [weak self] error in
                self?.isLoading.accept(false)
                return .empty()
            }
            .compactMap { [weak self] cards -> [MyCardCellViewModel]? in
                guard let self = self else { return nil }
                return self.myCardCellViewModel(cards)
            }
            .bind(onNext: { [weak self] in
                self?.myCardList.accept($0)
                self?.isLoading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapCardCreation() {
        navigation.accept(.push(.cardCreation))
    }
    
    func tapCard(at index: Int) {
        guard let selectedCard = myCardList.value[safe: 0] else { return }
        let selectedCardID = selectedCard.id
        navigation.accept(.push(.cardDetail(cardID: selectedCardID)))
    }
    
    private func myCardCellViewModel(_ cards: [Entity.NameCard]) -> [MyCardCellViewModel] {
        return cards.compactMap { card -> MyCardCellViewModel? in
            guard let personalSkills = card.personalSkills,
                  let bgColors = card.bgColor?.value,
                  let colorSource = ColorSource.from(bgColors)
            else { return nil }
            let skills = personalSkills.map { MySkillProgressView.Item(title: $0.name, level: $0.level ?? 0) }
            return MyCardCellViewModel(id: card.id ?? 0,
                                       image: card.imgUrl ?? .empty,
                                       name: card.name ?? .empty,
                                       role: card.role ?? .empty,
                                       skills: skills,
                                       backgroundColor: colorSource)
        }
    }
}
