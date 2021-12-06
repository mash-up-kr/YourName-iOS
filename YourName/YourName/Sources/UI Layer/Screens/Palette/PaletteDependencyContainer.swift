//
//  PaletteDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation


final class PaletteDependencyContainer {
    
    let selectedColorID: Identifier?
    let paletteResponder: PaletteResponder
    
    
    init(
        selectedColorID: Identifier?,
        cardCreationDependencyContainer: CardInfoInputDependencyContainer) {
            self.selectedColorID = selectedColorID
        self.paletteResponder = cardCreationDependencyContainer.viewModel
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
        let profileColorRepository = createProfileColorRepository()
        let viewModel = PaletteViewModel(profileColorRepository: profileColorRepository,
                                         paletteResponder: paletteResponder)
        return viewModel
    }
    
    private func createProfileColorRepository() -> ColorRepository {
        let repository = YourNameColorRepository()
//        FakeColorRepository()
//        repository.stubedProfileColors = [
//            YourNameColor(id: 1, colorSource: .monotone(Palette.vilolet), status: .normal),
//            YourNameColor(id: 2, colorSource: .monotone(Palette.pink), status: .normal),
//            YourNameColor(id: 3, colorSource: .monotone(Palette.orange), status: .normal),
//            YourNameColor(id: 4, colorSource: .monotone(Palette.yellow), status: .normal),
//            YourNameColor(id: 5, colorSource: .monotone(Palette.lightGreen), status: .normal),
//            YourNameColor(id: 6, colorSource: .monotone(Palette.skyBlue), status: .normal),
//            YourNameColor(id: 7, colorSource: .gradient([Palette.yellow, Palette.lightGreen, Palette.orange, Palette.pink, Palette.vilolet]), status: .locked),
//            YourNameColor(id: 8, colorSource: .gradient([Palette.skyBlue, Palette.pink, Palette.yellow]), status: .normal),
//        ]
        return repository
    }
    
    private func createColorSourceRepository() -> ColorSourceRepository {
        let mockColorSourceRepository = MockColorSourceRepository()
        return mockColorSourceRepository
    }
}
