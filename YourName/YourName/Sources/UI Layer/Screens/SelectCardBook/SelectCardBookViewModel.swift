//
//  SelectCardBookViewModel.swift
//  MEETU
//
//  Created by seori on 2021/11/13.
//

import Foundation
import RxSwift
import RxRelay

enum SelectCardBookDestination: Equatable {
    case addCardBook
}

typealias SelectCardBookNavigation = Navigation<SelectCardBookDestination>

final class SelectCardBookViewModel {
    
    typealias Item = SelectCardBookCollectionViewCell.Item
    var items: [SelectCardBookCollectionViewCell.Item] = [.init(name: "도감명", count: 24, backgroundColor: Palette.pink)]
    
    let navigation = PublishRelay<SelectCardBookNavigation>()
    
    func didTapAddCardButton() {
        self.navigation.accept(.push(.addCardBook))
    }
    func numberOfItems(section: Int) -> Int {
        return items.count
    }
    func cellForItem(at indexPath: IndexPath) -> Item? {
        return self.items[safe: indexPath.row]
    }
}
