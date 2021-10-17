//
//  PaletteViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import Foundation
import RxRelay
import RxSwift

protocol PaletteResponder {
    func profileColorSettingDidComplete(selectedColor: ProfileColor)
}

final class PaletteViewModel {
    
    let profileColors = BehaviorRelay<[ProfileColor]>(value: [])
    let canBeCompleted = BehaviorRelay<Bool>(value: false)
    
    init(
        profileColorRepository: ProfileColorRepository,
        paletteResponder: PaletteResponder
    ) {
        self.profileColorRepository = profileColorRepository
        self.paletteResponder = paletteResponder
    }
    
    func didLoad() {
        profileColorRepository.fetchAll()
            .bind(to: profileColors)
            .disposed(by: disposeBag)
    }

    func selectColor(at selectedIndex: Int) {
        let updatedColors = self.profileColors.value.indices
            .compactMap { index -> ProfileColor? in
                guard var color = self.profileColors.value[safe: index] else { return nil }
                if index == selectedIndex { color.status = .selected }
                else if color.status == .selected { color.status = .normal }
                return color
            }
        
        let canBeCompleted = updatedColors.map { $0.status }.reduce(false) { $0 || $1 == .selected }
        
        self.profileColors.accept(updatedColors)
        self.canBeCompleted.accept(canBeCompleted)
    }
    
    func tapComplete() {
        guard canBeCompleted.value else { return }
        guard let selectedColor = self.profileColors.value.first(where: { $0.status == .selected }) else { return }
        
        paletteResponder.profileColorSettingDidComplete(selectedColor: selectedColor)
    }
    
    private let disposeBag = DisposeBag()
    private let profileColorRepository: ProfileColorRepository
    private let paletteResponder: PaletteResponder
    
}
