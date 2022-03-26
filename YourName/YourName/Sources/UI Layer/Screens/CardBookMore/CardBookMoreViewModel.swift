//
//  CardBookMoreViewModel.swift
//  MEETU
//
//  Created by Seori on 2022/03/26.
//

import Foundation
import RxRelay

protocol CardBookMoreViewListener: AnyObject {
    func didTapAddMember()
    func didTapDeleteMember()
    func didTapEditCardBook()
    func didTapDeleteCardBook()
}

final class CardBookMoreViewModel {
    let cardBookName: BehaviorRelay<String>
    let isCardEmpty: BehaviorRelay<Bool>
    let dismiss: PublishRelay<Void>
    unowned var deletate: CardBookMoreViewListener!
    
    init(
        cardBookName: String,
        isCardEmpty: Bool,
        delegate: CardBookMoreViewListener
    ) {
        self.cardBookName = .init(value: "")
        self.isCardEmpty = .init(value: false)
        self.dismiss = .init()
        
        self.deletate = delegate
        self.cardBookName.accept(cardBookName)
        self.isCardEmpty.accept(isCardEmpty)
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    
    func didTapAddMember() {
        self.dismiss.accept(())
        self.deletate.didTapAddMember()
    }
    
    func didTapDeleteMember() {
        self.dismiss.accept(())
        self.deletate.didTapDeleteMember()
    }
    func didTapEditCardBook() {
        self.dismiss.accept(())
        self.deletate.didTapEditCardBook()
    }
    func didTapDeleteCardBook() {
        self.dismiss.accept(())
        self.deletate.didTapDeleteCardBook()
    }
}
