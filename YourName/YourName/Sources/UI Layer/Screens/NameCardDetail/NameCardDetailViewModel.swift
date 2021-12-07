//
//  NameCardDetail.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import Foundation
import RxSwift
import RxCocoa

final class NameCardDetailViewModel {
    
    enum State {
        case front(FrontCardDetailViewModel)
        case back(BackCardDetailViewModel)
    }
    
    let state = BehaviorRelay<State?>(value: nil)
    let backgroundColor = BehaviorRelay<ColorSource?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let shouldClose = PublishRelay<Void>()
    let shouldShowCopyToast = PublishRelay<Void>()
    let card = BehaviorRelay<Entity.NameCard?>(value: nil)
    
    init(cardID: Identifier,
         cardRepository: CardRepository,
         clipboardService: ClipboardService) {
        self.cardID = cardID
        self.cardRepository = cardRepository
        self.clipboardService = clipboardService
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        self.cardRepository.fetchCard(uniqueCode: self.cardID)
            .map { $0.nameCard }
            .filterNil()
            .subscribe(onNext: { [weak self] card in
                guard let self = self else { return }
                
                self.backgroundColor.accept(ColorSource.from(card.bgColor?.value ?? []))
                self.card.accept(card)
                self.isLoading.accept(false)
                guard let state = self.createFrontCardDetailViewModel(card) else { return }
                
                self.state.accept(.front(state))
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapBack() {
        self.shouldClose.accept(Void())
    }
    
    func tapCopy() {
        self.clipboardService.copy(self.cardID)
        self.shouldShowCopyToast.accept(Void())
    }
    
    func tapMore() {}
    
    func tapFrontCard() {
        guard let card = self.card.value else { return }
        guard let viewModel = self.createFrontCardDetailViewModel(card) else { return }
        self.state.accept(.front(viewModel))
    }
    
    func tapBackCard() {
        guard let card = self.card.value else { return }
        guard let viewModel = self.createBackCardDetailViewModel(card) else { return }
        self.state.accept(.back(viewModel))
    }
    
    private func createFrontCardDetailViewModel(_ card: Entity.NameCard) -> FrontCardDetailViewModel? {
        guard let id = card.uniqueCode else { return nil }
        
        let imageSource: ImageSource? = {
            guard let url = URL(string: card.imgUrl ?? .empty) else { return nil }
            return .url(url)
        }()
        let name = card.name
        let role = card.role
        let skills = card.personalSkills?.map { MySkillProgressView.Item(title: $0.name, level: $0.level ?? 0) } ?? []
        return FrontCardDetailViewModel(cardID: id,
                                        profileImageSource: imageSource,
                                        name: name,
                                        role: role,
                                        skills: skills)
    }
    
    private func createBackCardDetailViewModel(_ card: Entity.NameCard) -> BackCardDetailViewModel? {
        return BackCardDetailViewModel(personality: card.personality,
                                       contacts: card.contacts ?? [],
                                       tmis: card.tmis ?? [],
                                       aboutMe: card.introduce)
    }
    
    private let disposeBag = DisposeBag()
    
    private let cardID: Identifier
    private let cardRepository: CardRepository
    private let clipboardService: ClipboardService
}
