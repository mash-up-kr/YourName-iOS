//
//  SkillSettingDependencyContainer.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import Foundation



final class SkillSettingDependencyContainer {
    
    init(cardCreationDependencyContainer: CardCreationDependencyContainer) {
        
    }
    
    func createSkillSettingViewController() -> SkillSettingViewController {
        return SkillSettingViewController()
    }
    
}
