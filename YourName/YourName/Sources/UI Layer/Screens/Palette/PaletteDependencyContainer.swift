//
//  PaletteDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

final class PaletteDependencyContainer {
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        
    }
    
    func createPaletteViewController() -> PaletteViewController {
        return PaletteViewController()
    }
}
