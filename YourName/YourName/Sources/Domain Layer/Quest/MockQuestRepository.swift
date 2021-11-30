//
//  MockQuestUseCase.swift
//  MEETU
//
//  Created by Booung on 2021/11/27.
//

import Foundation
import RxSwift

final class MockQuestRepository: QuestRepository {
    
    func fetchAll() -> Observable<[Quest]> {
        return .just(Quest.dummyList).delay(.seconds(1), scheduler: ConcurrentMainScheduler.instance)
    }
    
    func updateQuest(_ meta: QuestMeta, to status: Quest.Status) -> Observable<Void> {
        return .empty()
    }
    
}
