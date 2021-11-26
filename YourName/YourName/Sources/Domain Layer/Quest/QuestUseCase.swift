//
//  QuestManager.swift
//  MEETU
//
//  Created by Booung on 2021/11/26.
//

import Foundation
import RxSwift

protocol QuestUseCase {
    func fetchAllQuests() -> Observable<[Quest]>
    func waitDoneQuest(_ questMeta: QuestMeta) -> Observable<Void>
    func doneQuest(_ questMeta: QuestMeta) -> Observable<Void>
}

final class YourNameQuestUseCase: QuestUseCase {
    
    init(questRepository: QuestRepository) {
        self.questRepository = questRepository
    }
    
    func fetchAllQuests() -> Observable<[Quest]> {
        return self.questRepository.fetchAll()
    }
    
    func waitDoneQuest(_ questMeta: QuestMeta) -> Observable<Void> {
        self.questRepository.updateQuest(questMeta, to: .waitingDone)
    }
    
    func doneQuest(_ questMeta: QuestMeta) -> Observable<Void> {
        self.questRepository.updateQuest(questMeta, to: .done)
    }
    
    private let questRepository: QuestRepository
    
}
