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

final class YourNameInterestRepository: InterestRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[Interest]> {
        return network.request(InterestesAPI())
            .compactMap { [weak self] characters in
                guard let self = self else { return nil }
                return characters.list?.compactMap(self.translate(fromTMI:))
            }
    }
    
    private func translate(fromTMI tmi: Entity.TMI) -> Interest? {
        guard let id = tmi.id                   else { return nil }
        guard let content = tmi.name            else { return nil }
        guard let urlString = tmi.iconURL       else { return nil }
        guard let url = URL(string: urlString)  else { return nil }
        
        return Interest(id: id, content: content, iconURL: url)
    }
    
    private let network: NetworkServing
    
}
