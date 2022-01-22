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
    func didTapRemoveCard(uniqueCode: UniqueCode)
    func didTapEditCard(uniqueCode: UniqueCode)
    func didTapSaveImage()
}

final class CardDetailMoreViewModel {
    
    private let uniqueCode: UniqueCode
    private let disposeBag = DisposeBag()
    private weak var delegate: CardDetailMoreViewDelegate?
    let dismiss = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    
    init(uniqueCode: UniqueCode,
         delegate: CardDetailMoreViewDelegate) {
        self.uniqueCode = uniqueCode
        self.delegate = delegate
    }
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    // MARK: - Methods
    
    func delete() {
        self.dismiss.accept(())
        self.delegate?.didTapRemoveCard(uniqueCode: self.uniqueCode)
    }
    
    func edit() {
        self.dismiss.accept(())
        self.delegate?.didTapEditCard(uniqueCode: self.uniqueCode)
    }
    
    func saveImage() {
        self.dismiss.accept(())
        self.delegate?.didTapSaveImage()
    }
}
