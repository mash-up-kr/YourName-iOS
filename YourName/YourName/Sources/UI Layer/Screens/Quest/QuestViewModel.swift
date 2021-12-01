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
    let progress = BehaviorRelay<Float>(value: 0)
    
    init(questUseCase: QuestUseCase) {
        self.questUseCase = questUseCase
        
        self.quests.map { [weak self] in self?.progress(ofQuests: $0) ?? 0 }
        .bind(to: progress)
        .disposed(by: self.disposeBag)
    }
    
    func didLoad() {
        self.isLoading.accept(true)
        self.loadQuests()
    }
    
    func tapClose() {
        self.shouldClose.accept(Void())
    }
    
    func tapAchieve(at index: Int) {
        guard let quest = self.quests.value[safe: index] else { return }
        guard let questStatus = quest.status             else { return }
        guard case .waitingDone = questStatus            else { return }
        guard let questMeta = quest.meta                 else { return }
        
        self.questUseCase.doneQuest(questMeta)
                .subscribe(onNext: { [weak self] in self?.loadQuests() })
                .disposed(by: self.disposeBag)
    }
    
    private func loadQuests() {
        self.questUseCase.fetchAllQuests()
            .subscribe(onNext: { [weak self] in
                self?.quests.accept($0)
                self?.isLoading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func progress(ofQuests quests: [Quest]) -> Float {
        let totalQuestCount = Float(quests.count)
        let doneQuestCount = Float(quests.filter { $0.status == .done }.count)
        return doneQuestCount / totalQuestCount
    }
    
    private let shouldUpdateQuest = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let questUseCase: QuestUseCase
    
}
