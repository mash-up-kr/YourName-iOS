//
//  AddCardViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import RxSwift
import RxCocoa

enum AddFriendCardDestination: Equatable {
    case cardDetail(cardID: Identifier)
}

typealias AddFriendCardNavigation = Navigation<AddFriendCardDestination>

final class AddFriendCardViewModel {
    typealias FrontCardItem = CardFrontView.Item
    typealias BackCardItem = AddFriendCardBackView.Item
    
    enum FriendCardState {
        case success(frontCardItem: FrontCardItem,
                     backCardItem: BackCardItem)
        case noResult
        case isAdded(frontCardItem: FrontCardItem,
                    backCardItem: BackCardItem)
        case isMine(frontCardItem: FrontCardItem,
                    backCardItem: BackCardItem)
    }
    
    // MARK: - Properties
    
    let isLoading = PublishRelay<Bool>()
    let addFriendCardResult = PublishRelay<FriendCardState>()
    let toastView = PublishRelay<ToastView>()
    let alertController = PublishRelay<AlertViewController>()
    let navigation = PublishRelay<AddFriendCardNavigation>()
    let popViewController = PublishRelay<Void>()
    
    let addFriendCardRepository: AddFriendCardRepository!
    let cardRepository: CardRepository!
    let questRepository: QuestRepository!
    
    private let disposeBag = DisposeBag()
    private let nameCard = BehaviorRelay<(id: Identifier?, uniqueCode: String?)>(value: (id: nil, uniqueCode: nil))
    
    // MARK: - Init
    
    init(addFriendCardRepository: AddFriendCardRepository,
         cardRepository: CardRepository,
         questRepository: QuestRepository) {
        self.addFriendCardRepository = addFriendCardRepository
        self.cardRepository = cardRepository
        self.questRepository = questRepository
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}

// MARK: - Methods

extension AddFriendCardViewModel {
    func searchMeetu(with uniqueCode: String) {
        self.isLoading.accept(true)
        let result = self.cardRepository.fetchCard(uniqueCode: uniqueCode)
            .do { [weak self] _ in
                self?.isLoading.accept(false)
            }
            .catchError { error in
                print(error)
                return .empty()
            }
            .share()
        
        // 해당 아이디가 없는 경우
        result
            .filter { $0.nameCard == nil }
            .mapToVoid()
            .map { FriendCardState.noResult }
            .bind(to: addFriendCardResult)
            .disposed(by: disposeBag)
        
        
        // 결과가 있는 경우
        let cardItem = result
            .filter { $0.nameCard != nil}
            .compactMap { [weak self] response -> (front: FrontCardItem, back: BackCardItem, isAdded: Bool, isMine: Bool)? in
                guard let self = self,
                      let nameCard = response.nameCard,
                      let personalSkills = nameCard.personalSkills,
                      let contacts = nameCard.contacts,
                      let bgColor = nameCard.bgColor?.value,
                      let isAdded = response.isAdded,
                      let isMine = response.isMine else { return nil }

                self.nameCard.accept((id: nameCard.id ?? .empty,
                                      uniqueCode: nameCard.uniqueCode ?? .empty))
                
                let bgColors: ColorSource!
                if bgColor.count == 1 { bgColors = .monotone(UIColor(hexString: bgColor.first!))}
                else { bgColors = .gradient(bgColor.map { UIColor(hexString: $0) } ) }
                
                let skills = personalSkills.map { MySkillProgressView.Item(title: $0.name,
                                                                           level: $0.level ?? 0) }
                let _contacts = contacts.map { AddFriendCardBackView.Item.Contact(image: $0.iconURL ?? .empty,
                                                                                 type: $0.category?.rawValue ?? .empty,
                                                                                 value: $0.value ?? .empty) }
                
                return (FrontCardItem(id: nameCard.id ?? .empty,
                                      image: nameCard.imgUrl ?? .empty,
                                      name: nameCard.name ?? .empty,
                                      role: nameCard.role ?? .empty,
                                      skills: skills,
                                      backgroundColor: bgColors),
                        BackCardItem(contacts: _contacts,
                                     personality: nameCard.personality ?? .empty,
                                     introduce: nameCard.introduce ?? .empty,
                                     backgroundColor: bgColors),
                        isAdded,
                        isMine)
            }
            .share()
        
        // 내 명함이 아님 + 추가되지않은상태
        cardItem
            .filter { (!$0.isAdded && !$0.isMine) }
            .map { frontCard, backCard, _, _ -> FriendCardState in
                return .success(frontCardItem: frontCard,
                                backCardItem: backCard)
            }
            .bind(to: addFriendCardResult)
            .disposed(by: self.disposeBag)
        
        // 내 명함이 아님 + 이미 추가된 경우
        cardItem
            .filter { ($0.isAdded && !$0.isMine) }
            .map { frontCard, backCard, _, _ -> FriendCardState in
                return .isAdded(frontCardItem: frontCard,
                                    backCardItem: backCard)
            }
            .bind(to: addFriendCardResult)
            .disposed(by: disposeBag)
        
        // 내 명함
        cardItem
            .filter { $0.isMine }
            .map { frontCard, backCard, _, _ -> FriendCardState in
                return .isMine(frontCardItem: frontCard,
                               backCardItem: backCard)
            }
            .bind(to: addFriendCardResult)
            .disposed(by: disposeBag)
    }
    
    func didTapAddButton() {
        self.isLoading.accept(true)
        
        guard let uniqueCode = self.nameCard.value.uniqueCode else { return }
        self.addFriendCardRepository.addFriendCard(uniqueCode: uniqueCode)
            .do { [weak self] _ in
                self?.isLoading.accept(false)
            }
            .catchError { error in
                print(error)
                return .empty()
            }
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.questRepository.updateQuest(.addFriendNameCard, to: .waitingDone)
                    .asObservable()
                    .mapToVoid()
            }
            .compactMap { [weak self] _ -> AlertViewController? in
                guard let self = self else { return nil }
                
                let alertController = AlertViewController.instantiate()
                
                let cardDetailAction = { [weak self] in
                    guard let self = self,
                          let nameCardID = self.nameCard.value.uniqueCode else { return }
                    alertController.dismiss()
                    
                    self.navigation.accept(.push(.cardDetail(cardID: nameCardID)))
                }
                let alertItem = AlertItem(title: "친구 미츄 추가완료!",
                                           message: "친구 미츄가 성공적으로 추가되었습니다.",
                                           image: UIImage(named: "meetu_addFriendCardAlert")!,
                                           emphasisAction: .init(title: "친구 미츄 상세보기", action: cardDetailAction),
                                           defaultAction: .init(title: "검색으로 돌아가기", action: { alertController.dismiss() }))
                
                self.toastView.accept(ToastView(text: "성공적으로 추가됐츄!"))
                self.searchMeetu(with: uniqueCode)
                alertController.configure(item: alertItem)
                return alertController
            }
            .bind(to: alertController)
            .disposed(by: disposeBag)
    }
}
