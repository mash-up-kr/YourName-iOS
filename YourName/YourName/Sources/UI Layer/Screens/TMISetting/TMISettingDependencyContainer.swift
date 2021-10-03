//
//  TMISettingDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

final class TMISettingDependencyContainer {
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        
    }
    
    func createTMISettingPageSheetController() -> PageSheetController<TMISettingView> {
        let view = TMISettingView()
        view.viewModel = createTMISettingViewModel()
        return PageSheetController(contentView: view)
    }
    
    private func createTMISettingViewModel() -> TMISettingViewModel {
        return TMISettingViewModel()
    }
    
}
