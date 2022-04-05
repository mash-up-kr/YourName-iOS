//
//  EditCardBookViewModel.swift
//  MEETU
//
//  Created by Seori on 2022/04/06.
//

import Foundation
import RxSwift
import RxRelay

final class EditCardBookViewModel: CreateCardBookViewModelType {

    
    typealias CardBookBgColorCellItem = CardBookCoverBackgroundColorCell.Item
    
    var cardBookCoverBgColors: BehaviorRelay<[CardBookBgColorCellItem]>
    var shouldNavigationPop: PublishRelay<Void>
    var colorRepository: ColorRepository
    var cardBookRepository: CardBookRepository
    var disposeBag: DisposeBag
    var cardBookName: BehaviorRelay<String>
    var cardBookDesc: BehaviorRelay<String>
    var cardBookBgColor: BehaviorRelay<Int>
    var confirmButtonEnabled: PublishRelay<Bool>
    private let cardBookID: CardBookID
    
    init(
        colorRepository: ColorRepository,
        cardBookRepository: CardBookRepository,
        cardBookID: CardBookID
    ) {
        self.colorRepository = colorRepository
        self.cardBookRepository = cardBookRepository
        self.cardBookCoverBgColors = .init(value: [])
        self.shouldNavigationPop = .init()
        self.disposeBag = .init()
        self.cardBookName = .init(value: "")
        self.cardBookDesc = .init(value: "")
        self.cardBookBgColor = .init(value: 0)
        self.confirmButtonEnabled = .init()
        
        self.cardBookID = cardBookID
    }
    
    func didTapConfrim() {
        guard let bgColorId = Int(self.cardBookCoverBgColors.value[safe: self.cardBookBgColor.value]?.id ?? "1") else { return }
        
        self.cardBookRepository.editCardBook(
            cardBookID: self.cardBookID,
            name: self.cardBookName.value,
            desc: self.cardBookDesc.value,
            bgColorId: bgColorId
        )
        .catchError { error in
            print("error -> \(error)")
            return .empty()
        }
        .bind(onNext: { [weak self] in
            self?.shouldNavigationPop.accept(())
            NotificationCenter.default.post(name: .cardBookDetailDidChange, object: nil)
            NotificationCenter.default.post(name: .cardBookDidChange, object: nil)
        })
        .disposed(by: self.disposeBag)
    }
    
    func fetch() {
        self.fetchColors()
        self.fetchCardBookInfo(id: self.cardBookID)
    }
    
    func fetchCardBookInfo(id: CardBookID) {
        self.cardBookRepository.fetchCardBook(id: id)
            .catchError { error in
                print("error -> \(error)")
                return .empty()
            }
            .compactMap { [weak self] cardBook -> (name: String, desc: String, selectedBgColorIndex: Int)? in
                guard let name = cardBook.name,
                      let desc = cardBook.description,
                      let bgColorId = cardBook.bgColor?.id,
                      let selectedBgColorIndex = self?.cardBookCoverBgColors.value.firstIndex(where: { item in
                          item.id == bgColorId
                      }) else { return nil }
                return (name, desc, selectedBgColorIndex)
            }
            .bind(onNext: { [weak self] name, desc, selectedBgColorIndex in
                self?.cardBookName.accept(name)
                self?.cardBookDesc.accept(desc)
                self?.bgIsSelected(at: selectedBgColorIndex)
            })
            .disposed(by: self.disposeBag)
    }
}
