//
//  CardCreationViewModelTests.swift
//  YourNameTests
//
//  Created by Booung on 2021/10/01.
//

import Nimble
import RxTest
import XCTest
@testable import YourName

final class CardCreationViewModelTests: XCTestCase {

    // π§ͺ System Under Test
    var sut: CardCreationViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.sut = CardCreationViewModel()
    }
    
    override func tearDown() {
        self.sut = nil
        
        super.tearDown()
    }
    
    func test_λνμ΄λ―Έμ§_νλ μ΄μ€νλλ₯Ό_ν΄λ¦­νλ©΄_λνμ΄λ―Έμ§_μ ννλ©΄μ_νμν©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(CardCreationNavigation.self)
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapProfilePlaceHolder()),
            .completed(300)
        ])
        testScheduler.start()
        
        
        //then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.show(.imageSourceTypePicker)]))
    }
    
    func test_λ°°κ²½μμ€μ λ²νΌμ_ν΄λ¦­νλ©΄_λ°°κ²½μμ€μ _νμ΄μ§μνΈλ₯Ό_νμν©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(CardCreationNavigation.self)
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapProfileBackgroundSetting()),
            .completed(300)
        ])
        testScheduler.start()
        
        //then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.show(.palette)]))
    }
    
    func test_μ΄λ¦μ_νμ΄ννλ©΄_μνμ_λ°μλ©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let nameObserver = testScheduler.createObserver(String.self)
        _ = sut.name.subscribe(nameObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typeName("γ")),
            .next(200, sut.typeName("μ΄")),
            .next(300, sut.typeName("μΌ")),
            .next(400, sut.typeName("μ΄λ₯΄")),
            .next(500, sut.typeName("μ΄λ¦")),
            .next(600, sut.typeName("μ΄λ₯΄λ―Έ")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let names = nameObserver.events.compactMap(\.value.element)
        expect(names).to(equal(["", "γ", "μ΄", "μΌ", "μ΄λ₯΄", "μ΄λ¦", "μ΄λ₯΄λ―Έ"]))
    }
    
    func  test_μ­ν μ_νμ΄ννλ©΄_μνμ_λ°μλ©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let roleObserver = testScheduler.createObserver(String.self)
        _ = sut.role.subscribe(roleObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typeRole("γ±")),
            .next(200, sut.typeRole("κ°")),
            .next(300, sut.typeRole("κ°­")),
            .next(400, sut.typeRole("κ°λ°")),
            .next(500, sut.typeRole("κ°λ°")),
            .next(600, sut.typeRole("κ°λ°γ")),
            .next(700, sut.typeRole("κ°λ°μ")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let roles = roleObserver.events.compactMap(\.value.element)
        expect(roles).to(equal(["", "γ±", "κ°", "κ°­", "κ°λ°", "κ°λ°", "κ°λ°γ", "κ°λ°μ"]))
    }
    
    func test_λμ_Skill_λ²νΌ_ν΄λ¦­μ_λ΄_Skillμ€μ _νλ©΄μΌλ‘_λ€λΉκ²μ΄μν©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(CardCreationNavigation.self)
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapSkillSetting()),
            .completed(300)
        ])
        testScheduler.start()
        
        //then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.show(.settingSkill)]))
    }
    
    func test_μ±κ²©_νμ΄νμ_νμ΄ννλ©΄_μνμ_λ°μλ©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let personalityTitleObserver = testScheduler.createObserver(String.self)
        _ = sut.personalityTitle.subscribe(personalityTitleObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typePersonalityTitle("E")),
            .next(200, sut.typePersonalityTitle("EN")),
            .next(300, sut.typePersonalityTitle("ENT")),
            .next(400, sut.typePersonalityTitle("ENTP")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let personalityTitles = personalityTitleObserver.events.compactMap(\.value.element)
        expect(personalityTitles).to(equal(["", "E","EN", "ENT", "ENTP"]))
    }
    
    func test_μ±κ²©_ν€μλμ_νμ΄ννλ©΄_μνμ_λ°μλ©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let personalityKeywordObserver = testScheduler.createObserver(String.self)
        _ = sut.personalityKeyword.subscribe(personalityKeywordObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typePersonalityKeyword("γ±")),
            .next(200, sut.typePersonalityKeyword("κ°")),
            .next(300, sut.typePersonalityKeyword("κ°")),
            .next(400, sut.typePersonalityKeyword("κ°γ")),
            .next(500, sut.typePersonalityKeyword("κ°μ")),
            .next(600, sut.typePersonalityKeyword("κ°μ±")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let personalityKeywords = personalityKeywordObserver.events.compactMap(\.value.element)
        expect(personalityKeywords).to(equal(["", "γ±", "κ°", "κ°", "κ°γ", "κ°μ", "κ°μ±"]))
    }
    
    func test_λμ_TMI_λ²νΌ_ν΄λ¦­μ_λμ_TMIμ€μ _νλ©΄μΌλ‘_λ€λΉκ²μ΄μν©λλ€() { // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(CardCreationNavigation.self)
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapTMISetting()),
            .completed(300)
        ])
        testScheduler.start()
        
        //then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.show(.settingTMI)]))
    }
    
    func test_About_Meλ₯Ό_νμ΄ννλ©΄_μνμ_λ°μλ©λλ€() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let aboutMeObserver = testScheduler.createObserver(String.self)
        _ = sut.aboutMe.subscribe(aboutMeObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typeAboutMe("γ")),
            .next(200, sut.typeAboutMe("μ")),
            .next(300, sut.typeAboutMe("μ")),
            .next(400, sut.typeAboutMe("μγ΄")),
            .next(500, sut.typeAboutMe("μλ")),
            .next(600, sut.typeAboutMe("μλ")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let aboutMes = aboutMeObserver.events.compactMap(\.value.element)
        expect(aboutMes).to(equal(["", "γ", "μ", "μ", "μγ΄", "μλ", "μλ"]))
    }
    
}
