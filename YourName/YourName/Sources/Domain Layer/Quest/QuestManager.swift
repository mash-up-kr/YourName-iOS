//
//  QuestManager.swift
//  MEETU
//
//  Created by Booung on 2021/11/26.
//

import Foundation
import RxSwift

enum QuestCode: String, Decodable {
    case makeFirstNameCard
    case shareMyNameCard
    case addFriendNameCard
    case makeFirstCardBook = "makeNewCollection"
    case makeThreeNameCards
}

protocol QuestUseCase {
    func fetchAllQuests() -> Observable<[Quest]>
    func waitDoneQuest(_ questCode: QuestCode) -> Observable<Void>
    func doneQuest(_ questCode: QuestCode) -> Observable<Void>
}

final class YourNameQuestUseCase: QuestUseCase {
    
    init(questRepository: QuestRepository) {
        self.questRepository = questRepository
    }
    
    func fetchAllQuests() -> Observable<[Quest]> {
        .just([])
    }
    
    
    func waitDoneQuest(_ questCode: QuestCode) -> Observable<Void> {
        .empty()
    }
    
    func doneQuest(_ questCode: QuestCode) -> Observable<Void> {
        .empty()
    }
    
    private let questRepository: QuestRepository
    
}
