//
//  PaletteViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation
import RxRelay
import RxSwift


final class PaletteViewModel {
    
    let profileColors = BehaviorRelay<[ProfileColor]>(value: [])
    
    
    init(profileColorRepository: ProfileColorRepository) {
        self.profileColorRepository = profileColorRepository
    }
    
    func didLoad() {
        profileColorRepository.fetchAll()
            .bind(to: profileColors)
            .disposed(by: disposeBag)
    }

    private let disposeBag = DisposeBag()
    private let profileColorRepository: ProfileColorRepository
}
