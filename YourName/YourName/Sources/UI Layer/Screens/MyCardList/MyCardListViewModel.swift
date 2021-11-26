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
        self.myCardRepository.fetchMyCards()
            .catchError { error in
                print(error)
                return .empty()
            }
            .compactMap { cards -> [MyCard]? in
                return cards.compactMap { card -> MyCard? in
                    
                    guard let personalSkills = card.personalSkills,
                          let bgColors = card.bgColor?.value else { return nil }
                    let skills = personalSkills.map { MySkillProgressView.Item(title: $0.name, level: $0.level?.rawValue ?? 0) }
                    
                    let bgColor: ColorSource!
                    
                    if bgColors.count == 1 {
                        bgColor = .monotone(UIColor(hexString: bgColors.first!))
                    } else {
                        bgColor = .gradient(bgColors.map { UIColor(hexString: $0) })
                    }
                    return MyCard(id: card.id ?? 0,
                                  image: card.image?.key ?? "",
                                  name: card.name ?? "",
                                  role: card.role ?? "",
                                  skills: skills,
                                  backgroundColor: bgColor)
                }
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
