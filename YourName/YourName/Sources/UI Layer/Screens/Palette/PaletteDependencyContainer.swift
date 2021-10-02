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
    
    func createPaletteViewController() -> PageSheetController<PaletteView> {
        let viewModel = PaletteViewModel()
        let view = PaletteView()
        return PageSheetController(
            title: "배경 컬러 선택하기",
            contentView: view
        )
    }
}
