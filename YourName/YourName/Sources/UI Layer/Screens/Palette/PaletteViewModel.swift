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
    func profileColorSettingDidComplete(selectedColor: YourNameColor)
}

final class PaletteViewModel {
    
    let profileColors = BehaviorRelay<[YourNameColor]>(value: [])
    let canBeCompleted = BehaviorRelay<Bool>(value: false)
    
    init(
        profileColorRepository: ColorRepository,
        paletteResponder: PaletteResponder
    ) {
        self.profileColorRepository = profileColorRepository
        self.paletteResponder = paletteResponder
    }
    
    func didLoad() {
        self.profileColorRepository.fetchAll()
            .bind(to: profileColors)
            .disposed(by: disposeBag)
    }

    func selectColor(at selectedIndex: Int) {
        guard let selectedColor = self.profileColors.value[safe: selectedIndex]  else { return }
        guard selectedColor.status != .locked                                    else { return }
        
        let updatedColors = self.profileColors.value.indices
            .compactMap { index -> YourNameColor? in
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
    private let profileColorRepository: ColorRepository
    private let paletteResponder: PaletteResponder
    
}
