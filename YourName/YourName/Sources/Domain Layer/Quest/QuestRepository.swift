//
//  QuestRepository.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation
import RxSwift

typealias Quest = Entity.Quest

protocol QuestRepository {
    func fetchAll() -> Observable<[Quest]>
    func updateQuest(_ meta: QuestMeta, to status: Quest.Status) -> Observable<Void>
}

final class YourNameQuestRepository: QuestRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[Quest]> {
        return network.request(QuestsAPI()).compactMap { $0.list }
    }
    
    func updateQuest(_ meta: QuestMeta, to status: Quest.Status) -> Observable<Void> {
        switch status {
        case .waitingDone:
            let api = QuestWaitingDoneAPI(questCode: meta.rawValue)
            return self.network.request(api).mapToVoid()
        case .done:
            let api = QuestDoneAPI(questCode: meta.rawValue)
            return self.network.request(api).mapToVoid()
        default:
            return .empty()
        }
    }
    
    private let network: NetworkServing
    
}

extension Quest {
    static let dummyList = [
        Quest(meta: .makeFirstCardBook, status: .notAchieved, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient1.png"),
        Quest(meta: .shareMyNameCard, status: .done, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient2.png"),
        Quest(meta: .addFriendNameCard, status: .waitingDone, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient3.png"),
        Quest(meta: .makeFirstCardBook, status: .notAchieved, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient4.png"),
        Quest(meta: .makeThreeNameCards, status: .notAchieved, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient5.png")
        ]
}
