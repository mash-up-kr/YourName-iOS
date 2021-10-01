//
//  CardCreationViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/01.
//

import Foundation
import RxRelay

enum CardCreationDestination: Equatable {
    case profileBackgroundSetting
    case createCharacter
    case mySkillSetting
    case myTMISetting
}

typealias CardCreationNavigation = Navigation<CardCreationDestination>

final class CardCreationViewModel {
    
    // State
    let shouldShowImageSelectOption = PublishRelay<Void>()
    let shouldHideClear = BehaviorRelay<Bool>(value: true)
    let shouldHideProfilePlaceholder = BehaviorRelay<Bool>(value: false)
    let name = BehaviorRelay<String>(value: .empty)
    let role = BehaviorRelay<String>(value: .empty)
    let personalityTitle = BehaviorRelay<String>(value: .empty)
    let personalityKeyword = BehaviorRelay<String>(value: .empty)
    let aboutMe = BehaviorRelay<String>(value: .empty)
    let navigation = PublishRelay<CardCreationNavigation>()
    
    // Event
    func tapProfilePlaceHolder() {
        shouldShowImageSelectOption.accept(Void())
    }
    
    func tapProfileBackgroundSetting() {
        navigation.accept(.present(.profileBackgroundSetting))
    }
    
    func typeName(_ text: String) {
        name.accept(text)
    }
    
    func typeRole(_ text: String) {
        role.accept(text)
    }
   
    func tapMySkillSetting() {
        navigation.accept(.present(.mySkillSetting))
    }
    
    func typePersonalityTitle(_ text: String) {
        personalityTitle.accept(text)
    }
    
    func typePersonalityKeyword(_ text: String) {
        personalityKeyword.accept(text)
    }
    
    func tapMyTMISetting() {
        navigation.accept(.present(.myTMISetting))
    }
    
    func typeAboutMe(_ text: String) {
        aboutMe.accept(text)
    }
    
    func tapCompletion() {
        
    }
}
