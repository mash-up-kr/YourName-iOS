//
//  TMISettingDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation

final class TMISettingDependencyContainer {
    
    let tmiSettingViewModel: TMISettingViewModel
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        
        func createInterestRepository() -> InterestRepository {
            let interestRepository = MockInterestRepository()
            interestRepository.stubedData = Interest.dummy
            return interestRepository
        }
        
        func createStrongPointRepository() -> StrongPointRepository {
            let strongPointRepository = MockStrongPointRepository()
            strongPointRepository.stubedData = StrongPoint.dummy
            return strongPointRepository
        }
        
        func createTMISettingViewModel(tmiSettingResponder: TMISettingResponder) -> TMISettingViewModel {
            let interestRepository = createInterestRepository()
            let strongPointRepository = createStrongPointRepository()
            return TMISettingViewModel(interestRepository: interestRepository,
                                       strongPointRepository: strongPointRepository,
                                       tmiSettingResponder: tmiSettingResponder)
        }
        let cardCreationViewModel = cardCreationDependencyContainer.viewModel
        self.tmiSettingViewModel = createTMISettingViewModel(tmiSettingResponder: cardCreationViewModel)
    }
    
    func createTMISettingViewController() -> TMISettingViewController {
        let view = TMISettingView()
        view.viewModel = tmiSettingViewModel
        return PageSheetController(contentView: view)
    }
    
}
