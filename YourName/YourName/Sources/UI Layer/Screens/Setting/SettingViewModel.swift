//
//  SettingViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/09.
//

import Foundation
import RxRelay

enum SettingDestination: Equatable {
    case userSetting
    case onboardingQuest
    case notice
    case aboutProductionTeam
}

typealias SettingNavigation = Navigation<SettingDestination>

final class SettingViewModel {
    private(set) var navigation = PublishRelay<SettingNavigation>()
    
    
    func tapOnboardingQuest() {
        navigation.accept(.show(.onboardingQuest))
    }
    func tapNotice() {
        print(#function)
//        navigation.accept(.push(.notice))
    }
    func tapAboutProductionTeam() {
        navigation.accept(.push(.aboutProductionTeam))
    }
    func tapLogOut() {
        UserDefaultManager.accessToken = nil
    }
    func tapResign() {
        
    }
}
