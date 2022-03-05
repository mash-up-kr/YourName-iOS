//
//  SelectCardBookViewModel.swift
//  MEETU
//
//  Created by seori on 2021/11/13.
//

import UIKit
import RxSwift
import RxRelay

enum SelectCardBookDestination: Equatable {
    case addCardBook
    case cardDetail(uniqueCode: UniqueCode, cardId: Identifier)
}

typealias SelectCardBookNavigation = Navigation<SelectCardBookDestination>

final class SelectCardBookViewModel {
    
    typealias Item = SelectCardBookCollectionViewCell.Item
    
    private var selectedIndex: [IndexPath] = []
    let isEnabledCompleteButton = BehaviorRelay<Bool>(value: false)
    let toastView = PublishRelay<ToastView>()
    var items: [SelectCardBookCollectionViewCell.Item] = [.init(name: "도감명", count: 24, backgroundColor: Palette.pink),
                                                          .init(name: "도감명", count: 24, backgroundColor: Palette.pink),
                                                          .init(name: "도감명", count: 24, backgroundColor: Palette.pink),.init(name: "도감명", count: 24, backgroundColor: Palette.pink)
    ,.init(name: "도감명", count: 24, backgroundColor: Palette.pink, isChecked: false),.init(name: "도감명", count: 24, backgroundColor: Palette.pink),
                                                          .init(name: "도감명", count: 24, backgroundColor: Palette.pink)
    ,.init(name: "도감명", count: 24, backgroundColor: Palette.pink)
    ,.init(name: "도감명", count: 24, backgroundColor: Palette.pink)
    ,.init(name: "도감명", count: 24, backgroundColor: Palette.pink)]
    
    let navigation = PublishRelay<SelectCardBookNavigation>()
    private let cardBookRepository: CardBookRepository
    
    init(cardBookRepository: CardBookRepository) {
        self.cardBookRepository = cardBookRepository
    }
 
    func didTapAddCardButton() {
        self.navigation.accept(.push(.addCardBook))
    }
    func numberOfItems(section: Int) -> Int {
        return items.count
    }
    func cellForItem(at indexPath: IndexPath) -> Item? {
        return self.items[safe: indexPath.row]
    }
    func didSelectCardBook(at indexPath: IndexPath) {
        if selectedIndex.contains(indexPath) {
            guard let index = selectedIndex.firstIndex(of: indexPath) else { return }
            selectedIndex.remove(at: index)
        } else {
            selectedIndex.append(indexPath)
        }
        if self.selectedIndex.isEmpty {
            self.isEnabledCompleteButton.accept(false)
        } else {
            self.isEnabledCompleteButton.accept(true)
        }
    }
    func didTapCompleteButton() {
        let toastView = ToastView(text: "성공적으로 추가됐츄!")
        self.toastView.accept(toastView)
    }
}
