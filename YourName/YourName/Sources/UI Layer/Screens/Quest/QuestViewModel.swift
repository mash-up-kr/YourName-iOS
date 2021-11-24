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
    
    let quests = BehaviorRelay<[Quest]>(value: [])
    
    init(questRepository: QuestRepository) {
        self.questRepository = questRepository
    }
    
    func didLoad() {
        questRepository.fetchAll()
            .subscribe(onNext: { [weak self] in self?.quests.accept($0) })
            .disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private let questRepository: QuestRepository
}

extension Quest: QuestTableViewCellPresentable {}

