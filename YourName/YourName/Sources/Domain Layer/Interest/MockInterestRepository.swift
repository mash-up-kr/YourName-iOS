//
//  MockInterestRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation
import RxSwift

final class MockInterestRepository: InterestRepository {
    
    var stubedData: [Interest] = []
    
    func fetchAll() -> Observable<[Interest]> {
        return .just(stubedData)
    }
    
}
