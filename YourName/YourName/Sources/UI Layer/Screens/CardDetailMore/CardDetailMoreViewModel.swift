//
//  CardDetailMoreViewModel.swift
//  MEETU
//
//  Created by seori on 2021/11/30.
//

import Foundation
import RxCocoa
import RxSwift

protocol CardDetailMoreViewDelegate: AnyObject {
    func didTapRemoveCard(id: Identifier)
    func didTapEditCard(id: Identifier)
}

final class CardDetailMoreViewModel {
    
    private let cardId: Identifier
    private let disposeBag = DisposeBag()
    private weak var delegate: CardDetailMoreViewDelegate?
    let dismiss = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    
    init(id: Identifier,
         delegate: CardDetailMoreViewDelegate) {
        self.cardId = id
        self.delegate = delegate
    }
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    // MARK: - Methods
    
    func delete() {
        self.dismiss.accept(())
        self.delegate?.didTapRemoveCard(id: self.cardId)
    }
    
    func edit() {
        self.dismiss.accept(())
    }
}
