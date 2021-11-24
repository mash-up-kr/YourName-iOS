//
//  InterestRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation
import RxSwift

protocol InterestRepository {
    func fetchAll() -> Observable<[Interest]>
}

final class InterestRepositoryImpl: InterestRepository {
    
    init(network: NetworkServing = Enviorment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[Interest]> {
        return network.request(BehaviorsAPI())
            .compactMap { [weak self] behaviors in
                guard let self = self else { return nil }
                return behaviors.list.compactMap(self.translate(fromTMI:))
            }
    }
    
    private func translate(fromTMI tmi: Entity.TMI) -> Interest? {
        guard let content = tmi.value else { return nil }
        return Interest(content: content)
    }
    
    private let network: NetworkServing
    
}
