//
//  CardBookDetailOptionViewModel.swift
//  MEETU
//
//  Created by Seori on 2022/03/12.
//

import Foundation

final class CardBookDetailOptionViewModelImp: CardBookDetailOptionViewModel {
    
    private let cardBookID: CardBookID
    init(cardBookID: CardBookID) {
       
        self.cardBookID = cardBookID
        print("\(String(describing: self)) init")
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
        print(#function)
    }
}
