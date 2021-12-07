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

enum NameCardDetailDestination: Equatable {
    case cardDetailMore(cardID: Identifier)
    case cardEdit(cardID: Identifier)
}

typealias NameCardDetailNavigation = Navigation<NameCardDetailDestination>

final class NameCardDetailViewModel {
    
    enum State {
        case front(FrontCardDetailViewModel)
        case back(BackCardDetailViewModel)
    }
    
    let alertController = PublishRelay<AlertViewController>()
    let navigation = PublishRelay<NameCardDetailNavigation>()
    let state = BehaviorRelay<State?>(value: nil)
    let backgroundColor = BehaviorRelay<ColorSource?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let shouldClose = PublishRelay<Void>()
    let card = BehaviorRelay<Entity.NameCard?>(value: nil)
    let captureBackCard = PublishRelay<Void>()
    let captureFrontCard = PublishRelay<Void>()
    let activityViewController = PublishRelay<UIActivityViewController>()
    
    init(cardID: Identifier, cardRepository: CardRepository, myCardRepository: MyCardRepository, questRepository: QuestRepository) {
        self.cardID = cardID
        self.cardRepository = cardRepository
        self.myCardRepository = myCardRepository
        self.questRepository = questRepository
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
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
    
    func tapMore() {
        self.navigation.accept(.show(.cardDetailMore(cardID: self.cardID)))
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
        guard let id = card.uniqueCode else { return nil }
        guard let colorSource = self.backgroundColor.value else { return nil }
        
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
    
    private let disposeBag = DisposeBag()
    
    private let cardID: Identifier
    private let cardRepository: CardRepository
    private let myCardRepository: MyCardRepository
    private let questRepository: QuestRepository
}

// MARK: - CardDetailMoreViewDelegate

extension NameCardDetailViewModel: CardDetailMoreViewDelegate {
    func didTapRemoveCard(id: Identifier) {
        
        let alertController = AlertViewController.instantiate()
        let deleteAction = { [weak self] in
            guard let self = self else { return }
            alertController.dismiss(animated: true)
            self.removeCard(id: id)
        }
        let deleteCancelAction = {
            alertController.dismiss(animated: true)
        }
        alertController.configure(item: AlertItem(title: "정말 삭제하시겠츄?",
                                                  message: "삭제한 미츄와 도감은 복구할 수 없어요.",
                                                  image: UIImage(named: "meetu_delete")!,
                                                  emphasisAction: .init(title: "삭제하기", action: deleteAction),
                                                  defaultAction: .init(title: "삭제 안할래요", action: deleteCancelAction)))
        self.alertController.accept(alertController)
    }
    
    func didTapEditCard(id: Identifier) {
        self.navigation.accept(.push(.cardEdit(cardID: self.cardID)))
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
    
    func saveCardImage(with view: UIView) {
        guard let image = YourNameSnapshotService.captureImage(view) else { return }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        vc.excludedActivityTypes = [.saveToCameraRoll]
        activityViewController.accept(vc)
        
        // Quest
        self.questRepository.updateQuest(.shareMyNameCard, to: .waitingDone)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    private func removeCard(id: Identifier) {
        self.isLoading.accept(true)
        self.myCardRepository.removeMyCard(id: id)
            .do { [weak self] in
                self?.isLoading.accept(false)
            }
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

