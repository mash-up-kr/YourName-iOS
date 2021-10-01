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

enum ImageSource: Equatable {
    case image(UIImage)
    case url(URL)
}

enum BackgroundColor: Equatable {
    case monotone(UIColor)
    case gradient([UIColor])
}

final class CardCreationViewModel {
    
    // State
    let shouldHideClear = BehaviorRelay<Bool>(value: true)
    let shouldHideProfilePlaceholder = BehaviorRelay<Bool>(value: false)
    let profileImageSource = BehaviorRelay<ImageSource?>(value: nil)
    let profileBackgroundColor = BehaviorRelay<BackgroundColor>(value: .monotone(Palette.black1))
    let name = BehaviorRelay<String>(value: .empty)
    let role = BehaviorRelay<String>(value: .empty)
    let personalityTitle = BehaviorRelay<String>(value: .empty)
    let personalityKeyword = BehaviorRelay<String>(value: .empty)
    let aboutMe = BehaviorRelay<String>(value: .empty)
    
    let shouldShowImageSelectOption = PublishRelay<Void>()
    let navigation = PublishRelay<CardCreationNavigation>()
    
    // Event
    func tapProfileClear() {
        
    }
    
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
    
    func selectContactType(_ type: ContactType, index: Int) {
        
    }
    
    func typeContactValue(_ value: String, index: Int) {
        
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
