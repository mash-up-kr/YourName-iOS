//
//  CardBookDetailOptionViewModel.swift
//  MEETU
//
//  Created by Seori on 2022/03/12.
//

import Foundation
import RxRelay

protocol CardBookDetailOptionViewModelDelegate: AnyObject {
    func didTapDeleteCardBook(id: CardBookID)
}

final class CardBookDetailOptionViewModel {
    
    private let cardBookID: CardBookID
    private weak var delegate: CardBookDetailOptionViewModelDelegate?
    let shouldDismiss: PublishRelay<Void>
    
    init(cardBookID: CardBookID,
         delegate: CardBookDetailOptionViewModelDelegate
    ) {
        self.delegate = delegate
        self.cardBookID = cardBookID
        self.shouldDismiss = .init()
    }
    
    
    func didTapBroughtFriend() {
        print(#function)
    }
    
    func didTapDeleteFriend() {
        print(#function)
    }
    
    func didTapEditCardBook() {
        print(#function)
    }
    
    func didTapDeleteCardBook() {
        self.shouldDismiss.accept(())
        self.delegate?.didTapDeleteCardBook(id: self.cardBookID)
    }
}
