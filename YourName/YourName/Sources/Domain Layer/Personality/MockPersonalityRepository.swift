//
//  MockPersonalityRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation
import RxSwift

final class MockPersonalityRepository: PersonalityRepository {
    
    var stubedData: [Personality] = []
    
    func fetchAll() -> Observable<[Personality]> {
        return .just(stubedData)
    }
}

