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

final class CardCreationViewModel {
    
    // State
    let shouldHideClear = BehaviorRelay<Bool>(value: true)
    let shouldHideProfilePlaceholder = BehaviorRelay<Bool>(value: false)
    let shouldDismiss = PublishRelay<Void>()
    let hasCompltedSkillInput = BehaviorRelay<Bool>(value: false)
    let hasCompltedTMIInput = BehaviorRelay<Bool>(value: false)
    let canComplete = BehaviorRelay<Bool>(value: false)
    
    let profileImageSource = BehaviorRelay<ImageSource?>(value: nil)
    let profileBackgroundColor = BehaviorRelay<ColorSource>(value: .monotone(Palette.black1))
    let skills = BehaviorRelay<[Skill]>(value: [])
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
        shouldDismiss.accept(Void())
    }
    
}
extension CardCreationViewModel: ImageSourcePickerResponder {
    
    func selectPhoto() {
        
    }
    
    func selectCharacter() {
        navigation.accept(.show(.createCharacter))
    }
    
}
extension CardCreationViewModel: SkillSettingResponder {
    
    func skillSettingDidComplete(skills: [Skill]) {
        hasCompltedSkillInput.accept(skills.isNotEmpty)
        self.skills.accept(skills)
    }
    
}
extension CardCreationViewModel: CharacterSettingResponder {
    
    func characterSettingDidComplete(characterMeta: CharacterMeta, characterData: Data) {
        shouldHideClear.accept(false)
        shouldHideProfilePlaceholder.accept(true)
        profileImageSource.accept(.data(characterData))
    }
    
}

