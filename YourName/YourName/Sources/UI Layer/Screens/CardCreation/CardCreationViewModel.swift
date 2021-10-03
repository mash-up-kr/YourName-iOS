//
//  CardCreationViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/01.
//

import Foundation
import RxRelay

enum CardCreationDestination: Equatable {
    case imageSourceTypePicker
    case createCharacter
    case palette
    case settingSkill
    case settingTMI
}

typealias CardCreationNavigation = Navigation<CardCreationDestination>

enum ImageSource: Equatable {
    case image(UIImage)
    case url(URL)
}

enum ColorSource: Equatable {
    case monotone(UIColor)
    case gradient([UIColor])
}

final class CardCreationViewModel {
    
    // State
    let shouldHideClear = BehaviorRelay<Bool>(value: true)
    let shouldHideProfilePlaceholder = BehaviorRelay<Bool>(value: false)
    let profileImageSource = BehaviorRelay<ImageSource?>(value: nil)
    let profileBackgroundColor = BehaviorRelay<ColorSource>(value: .gradient([Palette.yellow, Palette.lightGreen, Palette.skyBlue]))
    let name = BehaviorRelay<String>(value: .empty)
    let role = BehaviorRelay<String>(value: .empty)
    let personalityTitle = BehaviorRelay<String>(value: .empty)
    let personalityKeyword = BehaviorRelay<String>(value: .empty)
    let aboutMe = BehaviorRelay<String>(value: .empty)
    
    let navigation = PublishRelay<CardCreationNavigation>()
    
    // Event
    func tapProfileClear() {
        profileImageSource.accept(nil)
        shouldHideProfilePlaceholder.accept(false)
        shouldHideClear.accept(true)
    }
    
    func tapProfilePlaceHolder() {
        navigation.accept(.show(.imageSourceTypePicker))
    }
    
    func tapProfileBackgroundSetting() {
        navigation.accept(.show(.palette))
    }
    
    func tapCreatCharacter() {
        navigation.accept(.show(.createCharacter))
    }
    
    func typeName(_ text: String) {
        name.accept(text)
    }
    
    func typeRole(_ text: String) {
        role.accept(text)
    }
   
    func tapSkillSetting() {
        navigation.accept(.show(.settingSkill))
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
    
    func tapTMISetting() {
        navigation.accept(.show(.settingTMI))
    }
    
    func typeAboutMe(_ text: String) {
        aboutMe.accept(text)
    }
    
    func tapCompletion() {
        
    }
    
}
