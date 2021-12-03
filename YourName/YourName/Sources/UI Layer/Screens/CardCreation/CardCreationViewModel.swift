//
//  CardCreationViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/01.
//

import Foundation
import RxSwift
import RxRelay
import UIKit
import RxCocoa
import SwiftUI
import Then

enum CardCreationDestination: Equatable {
    case imageSourceTypePicker
    case createCharacter
    case palette
    case settingSkill
    case settingTMI
    case photoLibrary
}

typealias CardCreationNavigation = Navigation<CardCreationDestination>

struct TextStatus: Then {
    var isFull: Bool { self.count == max }
    var count: Int
    let max: Int
}


final class CardCreationViewModel {
    
    // State
    let isLoading = BehaviorRelay<Bool>(value: false)
    let shouldHideClear = BehaviorRelay<Bool>(value: true)
    let shouldHideProfilePlaceholder = BehaviorRelay<Bool>(value: false)
    let hasCompletedSkillInput = BehaviorRelay<Bool>(value: false)
    let hasCompletedTMIInput = BehaviorRelay<Bool>(value: false)
    let canComplete = BehaviorRelay<Bool>(value: false)
    let shouldClose = PublishRelay<Void>()
    let shouldDismissOverlays = PublishRelay<Void>()
    let indexOfContactTypeBeingSelected = BehaviorRelay<Int?>(value: nil)
    let profileImageSource = BehaviorRelay<ImageSource?>(value: nil)
    let profileImageKey = BehaviorRelay<ImageKey?>(value: nil)
    let profileBackgroundColor = BehaviorRelay<ColorSource>(value: .monotone(Palette.black1))
    let profileYourNameColorID = BehaviorRelay<Identifier?>(value: nil)
    let skills = BehaviorRelay<[Skill]>(value: [])
    let name = BehaviorRelay<String>(value: .empty)
    let role = BehaviorRelay<String>(value: .empty)
    let contactInfos = BehaviorRelay<[ContactInfo]>(value: [])
    let interestes = BehaviorRelay<[Interest]>(value: [])
    let strongPoints = BehaviorRelay<[StrongPoint]>(value: [])
    
    let personality = BehaviorRelay<String>(value: .empty)
    let personalityTextStatus = BehaviorRelay<TextStatus>(value: TextStatus(count: 0, max: 40))
    
    let aboutMe = BehaviorRelay<String>(value: .empty)
    let aboutMeTextStatus = BehaviorRelay<TextStatus>(value: TextStatus(count: 0, max: 40))
    
    let navigation = PublishRelay<CardCreationNavigation>()
    
    init(myCardRepsitory: MyCardRepository, imageUploader: ImageUploader) {
        self.myCardRepository = myCardRepsitory
        self.imageUploader = imageUploader
        
        self.transform()
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
        let status = personalityTextStatus.value.with { $0.count = text.count }
        self.personalityTextStatus.accept(status)
    }
    
    func tapTMISetting() {
        self.navigation.accept(.show(.settingTMI))
    }
    
    func typeAboutMe(_ text: String) {
        self.aboutMe.accept(text)
        let status = aboutMeTextStatus.value.with { $0.count = text.count }
        self.aboutMeTextStatus.accept(status)
    }
    
    func tapBack() {
        self.shouldClose.accept(Void())
    }
    
    func selectPhoto(data photoData: Data) {
        self.isLoading.accept(true)
        self.imageUploader.upload(imageData: photoData)
            .subscribe(onNext: { [weak self] imageKey in
                self?.isLoading.accept(false)
                self?.shouldHideClear.accept(false)
                self?.shouldHideProfilePlaceholder.accept(true)
                self?.profileImageSource.accept(.data(photoData))
                self?.profileImageKey.accept(imageKey)
                self?.isLoading.accept(false)
            })
            .disposed(by: self.disposeBag)
    }
    
    func tapCompletion() {
        let tmiIDs = self.interestes.value.compactMap { $0.id } + self.strongPoints.value.compactMap { $0.id }
        let skills = self.skills.value
            .filter { $0.title.isNotEmpty == true }
            .map { Entity.Skill(name: $0.title, level: $0.level) }
        let contacts = self.contactInfos.value
            .filter { $0.value.isNotEmpty == true }
            .map { Entity.Contact(category: $0.type, value: $0.value, iconURL: nil) }
        
        let nameCard = Entity.NameCardCreation(
            imgUrl: nil,
            bgColorId: self.profileYourNameColorID.value,
            name: self.name.value,
            role: self.role.value,
            skills: skills,
            contacts: contacts,
            personality: self.personality.value,
            introduce: self.aboutMe.value,
            tmiIds: tmiIDs,
            imageKey: self.profileImageKey.value ?? "profile/B0BBD1E8-2219-4C15-8CE5-A0A8A80C986E"
        )
        
        self.isLoading.accept(true)
        self.myCardRepository.createMyCard(nameCard)
            .subscribe(onNext: { [weak self] _ in
                NotificationCenter.default.post(name: .myCardsDidChange, object: nil)
                self?.isLoading.accept(false)
                self?.shouldClose.accept(Void())
            }, onError: { [weak self] _ in
                self?.isLoading.accept(false)
                self?.shouldClose.accept(Void())
            }, onDisposed: { [weak self] in
                self?.isLoading.accept(false)
                self?.shouldClose.accept(Void())
            })
            .disposed(by: self.disposeBag)
    }
    
    private func transform() {
        let hasName = self.name.map { $0.isNotEmpty }
        let hasRole = self.role.map { $0.isNotEmpty }
        let hasSkills = self.skills.map { $0.isNotEmpty }
        let hasContacts = self.contactInfos.map { $0.isNotEmpty }
        let hasPersonality = self.personality.map { $0.isNotEmpty }
        let hasIntroduce = self.aboutMe.map { $0.isNotEmpty }
        let hasInterests = self.interestes.map { $0.isNotEmpty }
        let hasStrongPoints = self.strongPoints.map { $0.isNotEmpty }
        let hasTMIs = Observable.combineLatest(hasInterests, hasStrongPoints).map { $0.0 || $0.1 }
        
        Observable.combineLatest([
            hasName,
            hasRole,
            hasSkills,
            hasContacts,
            hasContacts,
            hasPersonality,
            hasIntroduce,
            hasTMIs
        ]).map { predicates in predicates.allSatisfy { $0 } }
        .bind(to: self.canComplete)
        .disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    private let myCardRepository: MyCardRepository
    private let imageUploader: ImageUploader
}

extension CardCreationViewModel: ImageSourcePickerResponder {
    
    func selectPhoto() {
        self.navigation.accept(.show(.photoLibrary))
    }
    
    func selectCharacter() {
        self.navigation.accept(.show(.createCharacter))
    }
    
}

extension CardCreationViewModel: CharacterSettingResponder {
    
    func characterSettingDidComplete(characterMeta: CharacterMeta, characterData: Data) {
        self.isLoading.accept(true)
        self.imageUploader.upload(imageData: characterData)
            .subscribe(onNext: { [weak self] imageKey in
                self?.isLoading.accept(false)
                self?.shouldHideClear.accept(false)
                self?.shouldHideProfilePlaceholder.accept(true)
                self?.profileImageSource.accept(.data(characterData))
                self?.profileImageKey.accept(imageKey)
            })
            .disposed(by: self.disposeBag)
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
    
    func profileColorSettingDidComplete(selectedColor: YourNameColor) {
        self.profileBackgroundColor.accept(selectedColor.colorSource)
        self.shouldDismissOverlays.accept(Void())
    }
    
}
