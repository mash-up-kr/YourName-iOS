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
