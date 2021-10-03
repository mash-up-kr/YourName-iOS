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
    
    func createPalettePageSheetController() -> PageSheetController<PaletteView> {
        let view = createPaletteView()
        return PageSheetController(contentView: view)
    }
    
    private func createPaletteView() -> PaletteView {
        let view = PaletteView()
        view.viewModel = createPaletteViewModel()
        return view
    }
    
    private func createPaletteViewModel() -> PaletteViewModel {
        let repository = createProfileColorRepository()
        let viewModel = PaletteViewModel(profileColorRepository: repository)
        return viewModel
    }
    
    private func createProfileColorRepository() -> ProfileColorRepository {
        let mockProfileColorRepository = MockProfileColorRepository()
        return mockProfileColorRepository
    }
}
