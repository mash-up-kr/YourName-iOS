//
//  ColorSourceRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import RxSwift
import Foundation

protocol ProfileColorRepository {
    func fetchAll() -> Observable<[ProfileColor]>
}

final class MockProfileColorRepository: ProfileColorRepository {
    var stubedProfileColors: [ProfileColor] = []
    
    func fetchAll() -> Observable<[ProfileColor]> {
        return .just(stubedProfileColors)
    }
}
