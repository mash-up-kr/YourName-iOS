//
//  CardDetailMoreViewModel.swift
//  MEETU
//
//  Created by seori on 2021/11/30.
//

import Foundation
import RxCocoa
import RxSwift

final class CardDetailMoreViewModel {
    
    private let myCardRepository: MyCardRepository!
    private let cardId: CardID
    private let disposeBag = DisposeBag()
    init(repository: MyCardRepository,
         id: CardID) {
        self.cardId = id
        self.myCardRepository = repository
    }
    
    let alertController = PublishRelay<AlertViewController>()
    let popToRootViewController = PublishRelay<Void>()
    
    func delete() {
        let alertController = AlertViewController.instantiate()
        let deleteAction = { [weak self] in
            guard let self = self else { return }
            self.deleteMyCard(id: self.cardId)
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
    
    private func deleteMyCard(id: CardID) {
        self.myCardRepository.removeMyCard(id: cardId)
            .catchError { error in
                print(error)
                return .empty()
            }
            .bind(onNext: { [weak self] _ in
                print("card delete success")
                self?.popToRootViewController.accept(())
            })
            .disposed(by: self.disposeBag)
    }
}
