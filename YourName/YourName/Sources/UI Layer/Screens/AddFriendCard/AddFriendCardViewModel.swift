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
    case selectCardBook(friendCardUniqueCode: UniqueCode)
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
    private let nameCard = BehaviorRelay<(id: Identifier?, uniqueCode: UniqueCode?)>(value: (id: nil, uniqueCode: nil))
    
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
    func searchMeetu(with uniqueCode: UniqueCode) {
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
                                      uniqueCode: nameCard.uniqueCode ?? .empty,
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
       
        guard let uniqueCode = self.nameCard.value.uniqueCode else { return }
        let alertController = AlertViewController.instantiate()
        
        let selectCardBookAction = { [weak self] in
            guard let self = self else { return }
            alertController.dismiss()
            self.navigation.accept(.push(.selectCardBook(friendCardUniqueCode: uniqueCode)))
        }
        
        let skipAction = { [weak self] in
            guard let self = self else { return }
            alertController.dismiss()
            self.isLoading.accept(true)
            self.addFriendCardRepository.addFriendCard(at: ["1"], uniqueCode: uniqueCode)
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
                .bind(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.toastView.accept(ToastView(text: "성공적으로 추가됐츄!"))
                    NotificationCenter.default.post(name: .addFriendCard, object: nil)
                })
                .disposed(by: self.disposeBag)
        }
        
        let alertItem = AlertItem(title: "친구 미츄 추가완료!",
                                   messages: "친구 미츄가 성공적으로 추가되었습니다.",
                                   image: UIImage(named: "meetu_addFriendCardAlert")!,
                                   emphasisAction: .init(title: "도감 선택하기", action: selectCardBookAction),
                                   defaultAction: .init(title: "건너뛰기", action: skipAction))
        alertController.configure(item: alertItem)
        self.alertController.accept(alertController)
    
    }
}
