//
//  ColorSourceRepository.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import RxSwift
import Foundation

protocol ColorSourceRepository {
    func fetchAll() -> Observable<[ColorSource]>
}

final class MockColorSourceRepository: ColorSourceRepository {
    var stubedColorSources: [ColorSource] = []
    
    func fetchAll() -> Observable<[ColorSource]> {
        return .just(stubedColorSources)
    }
}
