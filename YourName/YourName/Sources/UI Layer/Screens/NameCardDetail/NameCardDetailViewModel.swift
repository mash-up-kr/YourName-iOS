//
//  NameCardDetail.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import Foundation
import RxSwift
import RxCocoa
import Photos
import UIKit

enum NameCardDetailDestination: Equatable {
    case cardDetailMore(uniqueCode: UniqueCode)
    case cardEdit(uniqueCode: UniqueCode)
}

typealias NameCardDetailNavigation = Navigation<NameCardDetailDestination>

final class NameCardDetailViewModel {
    
    enum State {
        case front(FrontCardDetailViewModel)
        case back(BackCardDetailViewModel)
    }
    enum CardType {
        case myCard
        case friendCard
    }
    
    let alertController = PublishRelay<AlertViewController>()
    let navigation = PublishRelay<NameCardDetailNavigation>()
    let state = BehaviorRelay<State?>(value: nil)
    let backgroundColor = BehaviorRelay<ColorSource?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let shouldClose = PublishRelay<Void>()
    let shouldShowCopyToast = PublishRelay<Void>()
    let card = BehaviorRelay<Entity.NameCard?>(value: nil)
    let captureBackCard = PublishRelay<Void>()
    let captureFrontCard = PublishRelay<Void>()
    let activityViewController = PublishRelay<UIActivityViewController>()
    let cardType = BehaviorRelay<CardType?>(value: nil)
    private let cardBookID: String
    init(cardId: Identifier?,
         uniqueCode: UniqueCode,
         cardRepository: CardRepository,
         myCardRepository: MyCardRepository,
         clipboardService: ClipboardService,
         questRepository: QuestRepository,
         cardType: CardType,
         cardBookID: String
    ) {
        self.cardBookID = cardBookID
        self.cardId = cardId
        self.uniqueCode = uniqueCode
        self.cardRepository = cardRepository
        self.myCardRepository = myCardRepository
        self.questRepository = questRepository
        self.clipboardService = clipboardService
        self.cardType.accept(cardType)
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        self.cardRepository.fetchCard(uniqueCode: self.uniqueCode)
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
        self.clipboardService.copy(self.uniqueCode)
        self.shouldShowCopyToast.accept(Void())
    }
    
    func tapAccessaryButton() {
        guard let cardType = self.cardType.value else { return }
        switch cardType {
        case .friendCard:
            guard let cardId = self.cardId else { return }
            let alertController = AlertViewController.instantiate()
            let deleteAction = { [weak self] in
                guard let self = self else { return }
                alertController.dismiss(animated: true)
                self.removeFriendCard(nameCardId: cardId)
            }
            let deleteCancelAction = {
                alertController.dismiss(animated: true)
            }
            alertController.configure(item: AlertItem(title: "정말 삭제하시겠츄?",
                                                      messages: "삭제한 미츄는 복구할 수 없어요.",
                                                      image: UIImage(named: "meetu_delete")!,
                                                      emphasisAction: .init(title: "삭제하기", action: deleteAction),
                                                      defaultAction: .init(title: "삭제 안할래요", action: deleteCancelAction)))
            self.alertController.accept(alertController)
            
        case .myCard:
            self.navigation.accept(.show(.cardDetailMore(uniqueCode: self.uniqueCode)))
        }
    }
    
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
        guard let uniqueCode = card.uniqueCode else { return nil }
        guard let colorSource = self.backgroundColor.value else { return nil }
        
        let imageSource: ImageSource? = {
            guard let url = URL(string: card.imgUrl ?? .empty) else { return nil }
            return .url(url)
        }()
        let name = card.name
        let role = card.role
        let skills = card.personalSkills?.map { MySkillProgressView.Item(title: $0.name, level: $0.level ?? 0) } ?? []
        
        return FrontCardDetailViewModel(uniqueCode: uniqueCode,
                                        profileImageSource: imageSource,
                                        name: name,
                                        role: role,
                                        skills: skills,
                                        backgroundColor: colorSource)
    }
    
    private func createBackCardDetailViewModel(_ card: Entity.NameCard) -> BackCardDetailViewModel? {
        guard let colorSource = self.backgroundColor.value else { return nil }
        return BackCardDetailViewModel(personality: card.personality,
                                       contacts: card.contacts ?? [],
                                       tmis: card.tmis ?? [],
                                       aboutMe: card.introduce,
                                       backgroundColor: colorSource)
    }
    
    private func removeFriendCard(nameCardId: Identifier) {
        
        self.isLoading.accept(true)
        self.cardRepository.remove(cardIDs: [nameCardId], on: self.cardBookID)
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .catchError { error in
                print(error)
                return .empty()
            }
            .mapToVoid()
            .bind(onNext: { [weak self] in
                NotificationCenter.default.post(name: .friendCardDidDelete, object: nil)
                self?.shouldClose.accept(())
            })
            .disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private let cardId: Identifier?
    private let uniqueCode: UniqueCode
    private let cardRepository: CardRepository
    private let clipboardService: ClipboardService
    private let myCardRepository: MyCardRepository
    private let questRepository: QuestRepository
}

// MARK: - CardDetailMoreViewDelegate

extension NameCardDetailViewModel: CardDetailMoreViewDelegate {
    func didTapRemoveCard(uniqueCode: UniqueCode) {
        
        let alertController = AlertViewController.instantiate()
        let deleteAction = { [weak self] in
            guard let self = self else { return }
            alertController.dismiss(animated: true)
            self.removeMyCard(uniqueCode: uniqueCode)
        }
        let deleteCancelAction = {
            alertController.dismiss(animated: true)
        }
        alertController.configure(item: AlertItem(title: "정말 삭제하시겠츄?",
                                                  messages: "삭제한 미츄는 복구할 수 없어요.",
                                                  image: UIImage(named: "meetu_delete")!,
                                                  emphasisAction: .init(title: "삭제하기", action: deleteAction),
                                                  defaultAction: .init(title: "삭제 안할래요", action: deleteCancelAction)))
        self.alertController.accept(alertController)
    }
    
    func didTapEditCard(uniqueCode: UniqueCode) {
        self.navigation.accept(.push(.cardEdit(uniqueCode: self.uniqueCode)))
    }
    
    func didTapSaveImage() {
        guard let state = self.state.value else { return }
        switch state {
        case .back:
            self.captureBackCard.accept(())
        case .front:
            self.captureFrontCard.accept(())
        }
    }
    
    func saveImage(view: UIScrollView) {
        guard let image = YourNameSnapshotService.captureToImage(view) else { return }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        self.activityViewController.accept(vc)
        
        // Quest
        self.questRepository.updateQuest(.saveMeetuMyAlbum, to: .waitingDone)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    private func removeMyCard(uniqueCode: UniqueCode) {
        self.isLoading.accept(true)
        self.myCardRepository.removeMyCard(uniqueCode: uniqueCode)
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .catchError { error in
                print(error)
                return .empty()
            }
            .mapToVoid()
            .bind(onNext: { [weak self] in
                NotificationCenter.default.post(name: .myCardDidDelete, object: nil)
                self?.shouldClose.accept(())
            })
            .disposed(by: self.disposeBag)
    }
}

