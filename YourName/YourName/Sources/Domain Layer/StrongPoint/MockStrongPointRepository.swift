//
//  MockStrongPointRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation
import RxSwift

final class MockStrongPointRepository: StrongPointRepository {
    
    var stubedData: [StrongPoint] = []
    
    func fetchAll() -> Observable<[StrongPoint]> {
        return .just(stubedData)
    }
    
}
