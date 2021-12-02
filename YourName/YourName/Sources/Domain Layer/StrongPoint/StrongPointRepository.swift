//
//  StrongPointRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation
import RxSwift

protocol StrongPointRepository {
    func fetchAll() -> Observable<[StrongPoint]>
}


final class YourNameStrongPointRepository: StrongPointRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[StrongPoint]> {
        return network.request(StrongPointsAPI())
            .compactMap { [weak self] behaviors in
                guard let self = self else { return nil }
                return behaviors.list?.compactMap(self.translate(fromTMI:))
            }
    }
    
    private func translate(fromTMI tmi: Entity.TMI) -> StrongPoint? {
        guard let id = tmi.id                   else { return nil }
        guard let content = tmi.name            else { return nil }
        guard let urlString = tmi.iconURL       else { return nil }
        guard let url = URL(string: urlString)  else { return nil }
        
        return StrongPoint(id: id, content: content, iconURL: url)
    }
    
    private let network: NetworkServing
    
}
