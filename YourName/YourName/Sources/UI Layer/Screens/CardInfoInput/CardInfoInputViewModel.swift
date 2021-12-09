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
import KakaoSDKCommon

enum CardCreationDestination: Equatable {
    case imageSourceTypePicker
    case createCharacter
    case palette(selectedColorID: Identifier? = nil)
    case settingSkill(skills: [Skill]? = nil)
    case settingTMI(interests: [Interest]? = nil, strongPoints: [StrongPoint]? = nil)
    case photoLibrary
}

typealias CardCreationNavigation = Navigation<CardCreationDestination>

struct TextStatus: Then {
    var isFull: Bool { self.count == max }
    var count: Int
    let max: Int
}

extension CardInfoInputViewModel {
    enum State {
        case new
        case edit(id: NameCardID)
    }
}

final class CardInfoInputViewModel {
    
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
    let interests = BehaviorRelay<[Interest]>(value: [])
    let strongPoints = BehaviorRelay<[StrongPoint]>(value: [])
    
    let personality = BehaviorRelay<String>(value: .empty)
    let personalityTextStatus = BehaviorRelay<TextStatus>(value: TextStatus(count: 0, max: 40))
    
    let aboutMe = BehaviorRelay<String>(value: .empty)
    let aboutMeTextStatus = BehaviorRelay<TextStatus>(value: TextStatus(count: 0, max: 40))
    
    let navigation = PublishRelay<CardCreationNavigation>()
    
    init(
        state: State,
        cardRepository: CardRepository?,
        myCardRepository: MyCardRepository,
        imageUploader: ImageUploader
    ) {
        self.state = state
        self.cardRepository = cardRepository
        self.myCardRepository = myCardRepository
        self.imageUploader = imageUploader
        
        self.transform()
    }
    
    // Event
    func didLoad() {
        let defaultContactInfos = ContactType.allCases.map { ContactInfo(type: $0, value: .empty) }
        self.contactInfos.accept(defaultContactInfos)
        
        guard case .edit(let id) = self.state else { return }
        
        self.isLoading.accept(true)
        self.cardRepository?.fetchCard(uniqueCode: id)
            .subscribe(onNext: { [weak self] response in
                guard let self = self              else { return }
                guard let card = response.nameCard else { return }
                self.setupCard(card)
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                print(error.localizedDescription)
                self?.isLoading.accept(false)
            }).disposed(by: self.disposeBag)
    }
    
    private func setupCard(_ card: Entity.NameCard) {
        let colorID = card.bgColor?.id
        let colorSource = ColorSource.from(card.bgColor?.value ?? [])
        let imageSource: ImageSource? = {
            guard let urlString = card.imgUrl      else { return nil }
            guard let url = URL(string: urlString) else { return nil }
            return .url(url)
        }()
        let name = card.name
        let role = card.role
        let contacts = card.contacts?.compactMap { contact in ContactInfo(type: contact.category ?? .email, value: contact.value ?? .empty) }
        let skills = card.personalSkills?.compactMap { skill in Skill(title: skill.name, level: skill.level ?? 0) }
        let interests = card.tmis?.filter { $0.type == "취미 / 관심사" }.compactMap { entity -> Interest? in
            guard let id = entity.id                                  else { return nil }
            guard let name = entity.name                              else { return nil }
            guard let iconURL = URL(string: entity.iconURL ?? .empty) else { return nil }
            
            return Interest(id: id, content: name, iconURL: iconURL)
        }
        let strongPoints = card.tmis?.filter { $0.type == "성격" }.compactMap { entity -> StrongPoint? in
            guard let id = entity.id                                  else { return nil }
            guard let name = entity.name                              else { return nil }
            guard let iconURL = URL(string: entity.iconURL ?? .empty) else { return nil }
            
            return StrongPoint(id: id, content: name, iconURL: iconURL)
        }
        let personality = card.personality
        let aboutMe = card.introduce
        
        if let colorID = colorID             { self.profileYourNameColorID.accept(colorID)      }
        if let colorSource = colorSource     { self.profileBackgroundColor.accept(colorSource)  }
        if let imageSource = imageSource     { self.profileImageSource.accept(imageSource)      }
        if let name = name                   { self.name.accept(name)                           }
        if let role = role                   { self.role.accept(role)                           }
        if let contacts = contacts           { self.contactInfos.accept(contacts)               }
        if let skills = skills               { self.skills.accept(skills)                       }
        if let colorID = colorID             { self.profileYourNameColorID.accept(colorID)      }
        if let interests = interests         { self.interests.accept(interests)                 }
        if let strongPoints = strongPoints   { self.strongPoints.accept(strongPoints)           }
        if let personality = personality     { self.personality.accept(personality)             }
        if let aboutMe = aboutMe             { self.aboutMe.accept(aboutMe)                     }
        
        self.shouldHideProfilePlaceholder.accept(imageSource != nil)
        self.hasCompletedSkillInput.accept(skills.isEmptyOrNil == false)
        self.hasCompletedTMIInput.accept(interests?.isNotEmpty == true || strongPoints?.isNotEmpty == true)
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
        self.navigation.accept(.show(.palette(selectedColorID: self.profileYourNameColorID.value)))
    }
    
    func typeName(_ text: String) {
        self.name.accept(text)
    }
    
    func typeRole(_ text: String) {
        self.role.accept(text)
    }
    
    func tapSkillSetting() {
        self.navigation.accept(.show(.settingSkill(skills: skills.value)))
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
        self.navigation.accept(.show(.settingTMI(interests: self.interests.value, strongPoints: self.strongPoints.value)))
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
        let tmiIDs = self.interests.value.compactMap { $0.id } + self.strongPoints.value.compactMap { $0.id }
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
            imageKey: self.profileImageKey.value
        )
        
        self.isLoading.accept(true)
        
        let updateMyCard: Observable<Void> = {
            switch self.state {
            case .new:          return self.myCardRepository.createMyCard(nameCard)
            case .edit(let id): return self.myCardRepository.updateMyCard(id: id, nameCard: nameCard)
            }
        }()
        
        updateMyCard.subscribe(onNext: { [weak self] _ in
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
        let hasInterests = self.interests.map { $0.isNotEmpty }
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
    
    private let state: State
    private let cardRepository: CardRepository?
    private let myCardRepository: MyCardRepository
    private let imageUploader: ImageUploader
}

extension CardInfoInputViewModel: ImageSourcePickerResponder {
    
    func selectPhoto() {
        self.navigation.accept(.show(.photoLibrary))
    }
    
    func selectCharacter() {
        self.navigation.accept(.show(.createCharacter))
    }
    
}

extension CardInfoInputViewModel: CharacterSettingResponder {
    
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

extension CardInfoInputViewModel: SkillSettingResponder {
    
    func skillSettingDidComplete(skills: [Skill]) {
        self.hasCompletedSkillInput.accept(skills.isNotEmpty)
        self.skills.accept(skills)
        self.shouldDismissOverlays.accept(Void())
    }
    
}

extension CardInfoInputViewModel: TMISettingResponder {
    
    func tmiSettingDidComplete(interests: [Interest], strongPoints: [StrongPoint]) {
        let updatedInterests = interests
        let updatedStrongPoints = strongPoints
        self.interests.accept(updatedInterests)
        self.strongPoints.accept(updatedStrongPoints)
        self.hasCompletedTMIInput.accept(updatedInterests.isNotEmpty || updatedStrongPoints.isNotEmpty)
        self.shouldDismissOverlays.accept(Void())
    }
    
}
extension CardInfoInputViewModel: PaletteResponder {
    
    func profileColorSettingDidComplete(selectedColor: YourNameColor) {
        self.profileBackgroundColor.accept(selectedColor.colorSource)
        self.profileYourNameColorID.accept(selectedColor.id)
        self.shouldDismissOverlays.accept(Void())
    }
    
}
