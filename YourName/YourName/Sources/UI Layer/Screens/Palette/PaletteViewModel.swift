//
//  PaletteViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation
import RxRelay


final class PaletteViewModel {
    
    init(profileColorRepository: ProfileColorRepository) {
        self.profileColorRepository = profileColorRepository
    }
    
    func didLoad() {
        
    }

    private let profileColorRepository: ProfileColorRepository
}
