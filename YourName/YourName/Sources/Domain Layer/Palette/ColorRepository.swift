//
//  ProfileColorRepository.swift
//  MEETU
//
//  Created by Booung on 2021/10/06.
//

import Foundation
import RxSwift

protocol ColorRepository {
    func fetchAll() -> Observable<[YourNameColor]>
}

final class YourNameColorRepository: ColorRepository {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func fetchAll() -> Observable<[YourNameColor]> {
        return network.request(ColorsAPI())
            .compactMap { [weak self] response in
                guard let self = self else { return nil }
                
                return response.list.compactMap { self.translate(fromEntity: $0) }
            }
    }
    
    private func translate(fromEntity entity: Entity.BackgroundColor) -> YourNameColor? {
        guard let id = entity.id else { return nil }
        guard let hexStrings = entity.value else { return nil }
        guard let colorSource = ColorSource.from(hexStrings) else { return nil }
        
        return YourNameColor(
            id: id,
            colorSource: colorSource,
            status: entity.isLocked.isTrueOrNil ? .locked : .normal
        )
    }
    
    private let network: NetworkServing
}

final class FakeColorRepository: ColorRepository {
    
    var stubedProfileColors: [YourNameColor] = []
    
    func fetchAll() -> Observable<[YourNameColor]> {
        return .just(stubedProfileColors)
    }
}
