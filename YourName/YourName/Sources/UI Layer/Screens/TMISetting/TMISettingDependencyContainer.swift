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
    
    func createTMISettingViewController() -> TMISettingViewController {
        let view = TMISettingView()
        view.viewModel = createTMISettingViewModel()
        return PageSheetController(contentView: view)
    }
    
    private func createTMISettingViewModel() -> TMISettingViewModel {
        let interestRepository = createInterestRepository()
        let strongPointRepository = createStrongPointRepository()
        return TMISettingViewModel(interestRepository: interestRepository,
                                   strongPointRepository: strongPointRepository)
    }
    
    private func createInterestRepository() -> InterestRepository {
        let interestRepository = MockInterestRepository()
        interestRepository.stubedData = Interest.dummy
        return interestRepository
    }
    
    private func createStrongPointRepository() -> StrongPointRepository {
        let strongPointRepository = MockStrongPointRepository()
        strongPointRepository.stubedData = StrongPoint.dummy
        return strongPointRepository
    }
}
