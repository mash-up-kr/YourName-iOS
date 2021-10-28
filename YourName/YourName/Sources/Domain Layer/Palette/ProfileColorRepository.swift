//
//  ProfileColorRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/06.
//

import Foundation
import RxSwift

protocol ProfileColorRepository {
    func fetchAll() -> Observable<[ProfileColor]>
}

final class FakeProfileColorRepository: ProfileColorRepository {
    
    var stubedProfileColors: [ProfileColor] = []
    
    func fetchAll() -> Observable<[ProfileColor]> {
        return .just(stubedProfileColors)
    }
}
