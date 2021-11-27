//
//  AddCardViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import RxSwift
import RxCocoa

final class AddFriendCardViewModel {
    typealias FrontCardItem = CardFrontView.Item
    typealias BackCardItem = AddFriendCardBackView.Item
    
    enum FriendCardState {
        case success(frontCardItem: FrontCardItem,
                     backCardItem: BackCardItem)
        case noResult
        case isAdded(frontCardItem: FrontCardItem,
                    backCardItem: BackCardItem)
        case none
    }
    
    // MARK: - Properties
    
    let isLoading = PublishRelay<Bool>()
    let addFriendCardResult = PublishRelay<FriendCardState>()
    let repository: AddFriendCardRepository!
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(repository: AddFriendCardRepository) {
        self.repository = repository
    }
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}

// MARK: - Methods

extension AddFriendCardViewModel {
    func didTapSearchButton(with uniqueCode: String) {
        self.isLoading.accept(true)
        let result = self.repository.searchFriendCard(uniqueCode: uniqueCode)
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
            .compactMap { response -> (front: FrontCardItem, back: BackCardItem, isAdded: Bool)? in
                guard let nameCard = response.nameCard,
                      let personalSkills = nameCard.personalSkills,
                      let contacts = nameCard.contacts,
                      let bgColor = nameCard.bgColor?.value,
                      let isAdded = response.isAdded else { return nil }
                
                let bgColors: ColorSource!
                if bgColor.count == 1 { bgColors = .monotone(UIColor(hexString: bgColor.first!))}
                else { bgColors = .gradient(bgColor.map { UIColor(hexString: $0) } ) }
                
                let skills = personalSkills.map { MySkillProgressView.Item(title: $0.name,
                                                                           level: $0.level?.rawValue ?? 0 ) }
                let _contacts = contacts.map { AddFriendCardBackView.Item.Contact(image: $0.iconURL ?? "",
                                                                                 type: $0.category?.rawValue ?? "",
                                                                                 value: $0.value ?? "") }
                
                return (FrontCardItem(id: nameCard.id ?? 0 ,
                                      image: nameCard.image ?? "",
                                      name: nameCard.name ?? "",
                                      role: nameCard.role ?? "",
                                      skills: skills,
                                      backgroundColor: bgColors),
                        BackCardItem(contacts: _contacts,
                                     personality: nameCard.personality ?? "",
                                     introduce: nameCard.introduce ?? "",
                                     backgroundColor: bgColors),
                        isAdded)
            }
            .share()
        
        // 이미 추가된 경우가 아님 (성공)
        cardItem
            .filter { !$0.isAdded }
            .map { frontCard, backCard, _ -> FriendCardState in
                return .success(frontCardItem: frontCard,
                                backCardItem: backCard)
            }
            .bind(to: addFriendCardResult)
            .disposed(by: self.disposeBag)
        
        // 이미 추가된 경우
        cardItem
            .filter { $0.isAdded }
            .map { frontCard, backCard, _ -> FriendCardState in
                return .isAdded(frontCardItem: frontCard,
                                    backCardItem: backCard)
            }
            .bind(to: addFriendCardResult)
            .disposed(by: disposeBag)
    }
}
