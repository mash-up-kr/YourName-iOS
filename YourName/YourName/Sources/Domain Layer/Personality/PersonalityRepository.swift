//
//  PersonalityRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation
import RxSwift

protocol PersonalityRepository {
    func fetchAll() -> Observable<[Personality]>
}

