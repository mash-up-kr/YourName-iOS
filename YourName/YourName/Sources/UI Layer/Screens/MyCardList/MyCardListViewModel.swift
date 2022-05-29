//
//  MyCardListViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import RxRelay
import RxSwift
import UIKit

enum MyCardListDestination: Equatable {
    case cardCreation
    case cardDetail(uniqueCode: UniqueCode)
    case quest
}

typealias MyCardListNavigation = Navigation<MyCardListDestination>
typealias MyCardCellViewModel = CardFrontView.Item

final class MyCardListViewModel {
    
    let navigation = PublishRelay<MyCardListNavigation>()
    let myCardViewModels = BehaviorRelay<[MyCardCellViewModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let alertViewController = PublishRelay<AlertViewController>()
    
    private let fetchAll = PublishRelay<Void>()
    private let fetchLoad = PublishRelay<Void>()
    private let myCardRepository: MyCardRepository
    private let questRepository: QuestRepository
    private let disposeBag = DisposeBag()
    
    init(myCardRepository: MyCardRepository,
         questRepository: QuestRepository) {
        self.questRepository = questRepository
        self.myCardRepository = myCardRepository
        self.bind()
    }
    
    deinit {
        print("💀 \(String(describing: self))")
    }
    
    private func bind() {
        self.fetchAll
            .bind(onNext: { [weak self] in
                self?.checkQuest()
            })
            .disposed(by: self.disposeBag)
        
        self.fetchLoad
            .bind(onNext: { [weak self] in
                self?.load()
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Methods
    
    func checkQuest() {
        self.questRepository.fetchAll()
            .compactMap { quests -> AlertViewController? in
                let index = quests.firstIndex(where: { quest in
                    return quest.meta == .makeFirstNameCard
                }) ?? 0
                guard let quest = quests[safe: index] else { return nil }
                if quest.status == .notAchieved {
                   
                    
                    let controller = AlertViewController.instantiate()
                    let confirmAction: () -> Void = { [weak self] in
                        controller.dismiss()
                        self?.navigation.accept(.present(MyCardListDestination.quest))
                    }
                    controller.configure(item: .init(title: "미츄를 만들어봐츄!",
                                                     messages: "미츄와 함께 퀘스트를 클리어하고,\n유니크 컬러를 획득하츄!",
                                                     image: UIImage(named: "icon_onboardingMeetU")!,
                                                     emphasisAction: .init(title: "퀘스트 확인하기",
                                                                           action: confirmAction),
                                                     defaultAction: .init(title: "건너뛰기",
                                                                          action: { controller.dismiss() })))
                    
                    return controller
                }
                return nil
            }
            .catchError { [weak self] error in
                self?.isLoading.accept(false)
                throw error
            }
            .catchErrorToAlert(self.alertViewController, retryHandler: self.fetchAll)
            .bind(to: self.alertViewController)
            .disposed(by: self.disposeBag)
    }
    
    func load() {
        self.isLoading.accept(true)
        self.myCardRepository.fetchMyCards()
            .catchError { [weak self] error in
                self?.isLoading.accept(false)
                throw error
            }
            .catchErrorToAlert(self.alertViewController, retryHandler: self.fetchLoad)
            .compactMap { [weak self] cards -> [MyCardCellViewModel]? in
                guard let self = self else { return nil }
                return self.myCardCellViewModel(cards)
            }
            .bind(onNext: { [weak self] in
                self?.myCardViewModels.accept($0)
                self?.isLoading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapCardCreation() {
        navigation.accept(.push(.cardCreation))
    }
    
    func tapCard(at index: Int) {
        guard let selectedCard = myCardViewModels.value[safe: index] else { return }
        navigation.accept(.push(.cardDetail(uniqueCode: selectedCard.uniqueCode)))
    }
    
    private func myCardCellViewModel(_ cards: [Entity.NameCard]) -> [MyCardCellViewModel] {
        return cards.compactMap { card -> MyCardCellViewModel? in
            guard let personalSkills = card.personalSkills,
                  let bgColors = card.bgColor?.value,
                  let colorSource = ColorSource.from(bgColors)
            else { return nil }
            let skills = personalSkills.map { MySkillProgressView.Item(title: $0.name, level: $0.level ?? 0) }
            return MyCardCellViewModel(id: card.id ?? .empty,
                                       uniqueCode: card.uniqueCode ?? .empty,
                                       image: card.imgUrl ?? .empty,
                                       name: card.name ?? .empty,
                                       role: card.role ?? .empty,
                                       skills: skills,
                                       backgroundColor: colorSource)
        }
    }
}
