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
                return behaviors.compactMap(self.translate(fromTMI:))
            }
    }
    
    private func translate(fromTMI tmi: Entity.TMI) -> Interest? {
        guard let id = tmi.id        else { return nil }
        guard let content = tmi.name else { return nil }
        
        return Interest(id: id, content: content)
    }
    
    private let network: NetworkServing
    
}
