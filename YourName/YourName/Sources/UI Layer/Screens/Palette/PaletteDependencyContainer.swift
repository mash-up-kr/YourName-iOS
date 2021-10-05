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
        let view = createPaletteView()
        return PaletteViewController(contentView: view)
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
        let repository = FakeProfileColorRepository()
        repository.stubedProfileColors = [
            ProfileColor(colorSource: .monotone(Palette.vilolet), status: .selected),
            ProfileColor(colorSource: .monotone(Palette.pink), status: .normal),
            ProfileColor(colorSource: .monotone(Palette.orange), status: .normal),
            ProfileColor(colorSource: .monotone(Palette.yellow), status: .normal),
            ProfileColor(colorSource: .monotone(Palette.lightGreen), status: .normal),
            ProfileColor(colorSource: .monotone(Palette.skyBlue), status: .normal),
            ProfileColor(colorSource: .gradient([Palette.yellow, Palette.lightGreen, Palette.orange, Palette.pink, Palette.vilolet]), status: .locked),
            ProfileColor(colorSource: .gradient([Palette.skyBlue, Palette.pink, Palette.yellow]), status: .normal),
        ]
        return repository
    }
    
    private func createColorSourceRepository() -> ColorSourceRepository {
        let mockColorSourceRepository = MockColorSourceRepository()
        return mockColorSourceRepository
    }
}
