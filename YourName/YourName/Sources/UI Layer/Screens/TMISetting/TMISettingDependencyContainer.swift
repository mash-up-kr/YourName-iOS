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
        let personalityRepository = createPersonalityRepository()
        return TMISettingViewModel(interestRepository: interestRepository,
                                   personalityRepository: personalityRepository)
    }
    
    private func createInterestRepository() -> InterestRepository {
        let interestRepository = MockInterestRepository()
        interestRepository.stubedData = Interest.dummy
        return interestRepository
    }
    
    private func createPersonalityRepository() -> PersonalityRepository {
        let personalityRepository = MockPersonalityRepository()
        personalityRepository.stubedData = Personality.dummy
        return personalityRepository
    }
}
