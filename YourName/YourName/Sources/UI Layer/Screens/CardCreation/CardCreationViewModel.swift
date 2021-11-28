//
//  CardCreationViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/01.
//

import Foundation
import RxSwift
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
    let hasCompletedSkillInput = BehaviorRelay<Bool>(value: false)
    let hasCompletedTMIInput = BehaviorRelay<Bool>(value: false)
    let canComplete = BehaviorRelay<Bool>(value: false)
    let shouldDismiss = PublishRelay<Void>()
    let shouldDismissOverlays = PublishRelay<Void>()
    let indexOfContactTypeBeingSelected = BehaviorRelay<Int?>(value: nil)
    let profileImageSource = BehaviorRelay<ImageSource?>(value: nil)
    let profileBackgroundColor = BehaviorRelay<ColorSource>(value: .monotone(Palette.black1))
    let skills = BehaviorRelay<[Skill]>(value: [])
    let name = BehaviorRelay<String>(value: .empty)
    let role = BehaviorRelay<String>(value: .empty)
    let contactInfos = BehaviorRelay<[ContactInfo]>(value: [])
    let personality = BehaviorRelay<String>(value: .empty)
    let interestes = BehaviorRelay<[Interest]>(value: [])
    let strongPoints = BehaviorRelay<[StrongPoint]>(value: [])
    let aboutMe = BehaviorRelay<String>(value: .empty)
    
    let navigation = PublishRelay<CardCreationNavigation>()
    
    init(myCardRepsitory: MyCardRepository) {
        self.myCardRepository = myCardRepsitory
    }
    
    // Event
    func didLoad() {
        let defaultContactInfos = ContactType.allCases.map { ContactInfo(type: $0, value: .empty) }
        self.contactInfos.accept(defaultContactInfos)
    }
    
    func tapProfileClear() {
        self.profileImageSource.accept(nil)
        self.shouldHideProfilePlaceholder.accept(false)
        self.shouldHideClear.accept(true)
    }
    
    func tapProfilePlaceHolder() {
        self.navigation.accept(.show(.imageSourceTypePicker))
    }
    
    func tapProfileBackgroundSetting() {
        self.navigation.accept(.show(.palette))
    }
    
    func typeName(_ text: String) {
        self.name.accept(text)
    }
    
    func typeRole(_ text: String) {
        self.role.accept(text)
    }
   
    func tapSkillSetting() {
        self.navigation.accept(.show(.settingSkill))
    }
    
    func tapContactType(at index: Int) {
        self.indexOfContactTypeBeingSelected.accept(index)
    }
    
    func selectContactType(_ type: ContactType, index: Int) {
        var updatedContactInfos = contactInfos.value
        guard var updatedContactInfo = updatedContactInfos[safe: index] else { return }
        
        updatedContactInfo.type = type
        updatedContactInfos[index] = updatedContactInfo
        self.contactInfos.accept(updatedContactInfos)
        self.indexOfContactTypeBeingSelected.accept(nil)
    }
    
    func typeContactValue(_ value: String, index: Int) {
        var updatedContactInfos = contactInfos.value
        guard var updatedContactInfo = updatedContactInfos[safe: index] else { return }
        
        updatedContactInfo.value = value
        updatedContactInfos[index] = updatedContactInfo
        self.contactInfos.accept(updatedContactInfos)
    }
    
    func typePersonality(_ text: String) {
        self.personality.accept(text)
    }
    
    func tapTMISetting() {
        self.navigation.accept(.show(.settingTMI))
    }
    
    func typeAboutMe(_ text: String) {
        self.aboutMe.accept(text)
    }
    
    func tapCompletion() {
        let nameCard = Entity.NameCard(
            id: nil,
            name: self.name.value,
            role: self.role.value,
            personality: self.personality.value,
            introduce: self.aboutMe.value,
            uniqueCode: nil,
            image: nil,
            user: nil,
            bgColor: nil,
            contacts: self.contactInfos.value.map { Entity.Contact(category: $0.type, value: $0.value, iconURL: nil) },
            personalSkills: self.skills.value.map { Entity.Skill(name: $0.title, level: $0.level) },
            bgColorId: nil
        )
        
        self.myCardRepository.createMyCard(nameCard)
            .subscribe(onNext: { [weak self] _ in
                self?.shouldDismiss.accept(Void())
            })
            .disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let myCardRepository: MyCardRepository
}

extension CardCreationViewModel: ImageSourcePickerResponder {
    
    func selectPhoto() {
        
    }
    
    func selectCharacter() {
        self.navigation.accept(.show(.createCharacter))
    }
    
}

extension CardCreationViewModel: CharacterSettingResponder {
    
    func characterSettingDidComplete(characterMeta: CharacterMeta, characterData: Data) {
        self.shouldHideClear.accept(false)
        self.shouldHideProfilePlaceholder.accept(true)
        self.profileImageSource.accept(.data(characterData))
    }
    
}

extension CardCreationViewModel: SkillSettingResponder {
    
    func skillSettingDidComplete(skills: [Skill]) {
        self.hasCompletedSkillInput.accept(skills.isNotEmpty)
        self.skills.accept(skills)
        self.shouldDismissOverlays.accept(Void())
    }
    
}

extension CardCreationViewModel: TMISettingResponder {
    
    func tmiSettingDidComplete(interests: [Interest], strongPoints: [StrongPoint]) {
        let updatedInterests = interests
        let updatedStrongPoints = strongPoints
        self.interestes.accept(updatedInterests)
        self.strongPoints.accept(updatedStrongPoints)
        self.hasCompletedTMIInput.accept(updatedInterests.isNotEmpty || updatedStrongPoints.isNotEmpty)
        self.shouldDismissOverlays.accept(Void())
    }
    
}
extension CardCreationViewModel: PaletteResponder {
    
    func profileColorSettingDidComplete(selectedColor: ProfileColor) {
        self.profileBackgroundColor.accept(selectedColor.colorSource)
        self.shouldDismissOverlays.accept(Void())
    }
    
}
