//
//  CardDetailViewModel.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation
import RxSwift
import RxCocoa

enum CardDetailDestination: Equatable {
    case cardDetailMore(cardID: Identifier)
    case cardEdit(cardID: Identifier)
}

typealias CardDetailNavigation = Navigation<CardDetailDestination>

final class CardDetailViewModel {
    
    let isLoading = PublishRelay<Bool>()
    let navigation = PublishRelay<CardDetailNavigation>()
    let navigationPop = PublishRelay<Void>()
    let alertController = PublishRelay<AlertViewController>()
    private let disposeBag = DisposeBag()
    private let cardID: Identifier
    private let myCardRepository: MyCardRepository!
    
    // MARK: - LifeCycle
    init(cardID: Identifier,
         repository: MyCardRepository) {
        self.cardID = cardID
        self.myCardRepository = repository
    }
     
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    // MARK: - Methods
    
    func didTapMore() {
        navigation.accept(.show(.cardDetailMore(cardID: self.cardID)))
    }
}

// MARK: - CardDetailMore delegate
extension CardDetailViewModel: CardDetailMoreViewDelegate {
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
        self.navigation.accept(.push(.cardEdit(cardID: id)))
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
                self?.navigationPop.accept(())
            })
            .disposed(by: self.disposeBag)
    }
}
