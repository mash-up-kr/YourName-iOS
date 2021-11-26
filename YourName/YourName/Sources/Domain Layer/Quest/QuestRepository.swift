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
}

final class QuestRepositoryImpl: QuestRepository {
    
    init(network: NetworkServing = Enviorment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[Quest]> {
        return network.request(QuestsAPI()).compactMap { $0.list }
    }
    
    private let network: NetworkServing
    
}

final class MockQuestRepository: QuestRepository {
    
    func fetchAll() -> Observable<[Quest]> {
        return .just(Quest.dummyList).delay(.seconds(1), scheduler: ConcurrentMainScheduler.instance)
    }
    
}
extension Quest {
    static let dummyList = [
        Quest(id: "", title: "나의 첫 미츄 만들기", status: .wait, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient1.png"),
        Quest(id: "", title: "나의 미츄 공유하기", status: .done, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient2.png"),
        Quest(id: "", title: "친구 1명 추가하기", status: .archieve, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient3.png"),
        Quest(id: "", title: "새로운 도감 만들기", status: .wait, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient4.png"),
        Quest(id: "", title: "미츄 3개 이상 만들기", status: .wait, rewardImageURL: "https://erme.s3.ap-northeast-2.amazonaws.com/user_onboarding/Gradient5.png")
        ]
}
