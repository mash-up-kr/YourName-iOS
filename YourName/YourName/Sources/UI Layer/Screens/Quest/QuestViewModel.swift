//
//  QuestViewModel.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation
import RxSwift
import RxRelay

final class QuestViewModel {
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let shouldClose = PublishRelay<Void>()
    let quests = BehaviorRelay<[Quest]>(value: [])
    
    init(questRepository: QuestRepository) {
        self.questRepository = questRepository
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        questRepository.fetchAll()
            .subscribe(onNext: { [weak self] in
                self?.quests.accept($0)
                self?.isLoading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapClose() {
        self.shouldClose.accept(Void())
    }
    
    private let disposeBag = DisposeBag()
    private let questRepository: QuestRepository
}

extension Quest: QuestTableViewCellPresentable {}

