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

    // 🧪 System Under Test
    var sut: CardCreationViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.sut = CardCreationViewModel()
    }
    
    override func tearDown() {
        self.sut = nil
        
        super.tearDown()
    }
    
    func test_대표이미지_플레이스홀더를_클릭하면_대표이미지_선택화면을_표시합니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let shouldShowImageSelectOptionObserver = testScheduler.createObserver(Void.self)
        _ = sut.shouldShowImageSelectOption.subscribe(shouldShowImageSelectOptionObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapProfilePlaceHolder()),
            .completed(300)
        ])
        testScheduler.start()
        
        //then
        let shouldShowImageSelectOption: [Void] = shouldShowImageSelectOptionObserver.events.compactMap(\.value.element)
        expect(shouldShowImageSelectOption).to(haveCount(1))
    }
    
    func test_배경색설정버튼을_클릭하면_배경색설정_화면으로_네비게이션합니다() {
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
        expect(navigations).to(equal([.present(.profileBackgroundSetting)]))
    }
    
    func test_이름을_타이핑하면_상태에_반영됩니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let nameObserver = testScheduler.createObserver(String.self)
        _ = sut.name.subscribe(nameObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typeName("ㅇ")),
            .next(200, sut.typeName("이")),
            .next(300, sut.typeName("일")),
            .next(400, sut.typeName("이르")),
            .next(500, sut.typeName("이름")),
            .next(600, sut.typeName("이르미")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let names = nameObserver.events.compactMap(\.value.element)
        expect(names).to(equal(["", "ㅇ", "이", "일", "이르", "이름", "이르미"]))
    }
    
    func  test_역할을_타이핑하면_상태에_반영됩니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let roleObserver = testScheduler.createObserver(String.self)
        _ = sut.role.subscribe(roleObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typeRole("ㄱ")),
            .next(200, sut.typeRole("개")),
            .next(300, sut.typeRole("갭")),
            .next(400, sut.typeRole("개바")),
            .next(500, sut.typeRole("개발")),
            .next(600, sut.typeRole("개발ㅈ")),
            .next(700, sut.typeRole("개발자")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let roles = roleObserver.events.compactMap(\.value.element)
        expect(roles).to(equal(["", "ㄱ", "개", "갭", "개바", "개발", "개발ㅈ", "개발자"]))
    }
    
    func test_나의_Skill_버튼_클릭시_내_Skill설정_화면으로_네비게이션합니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(CardCreationNavigation.self)
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapMySkillSetting()),
            .completed(300)
        ])
        testScheduler.start()
        
        //then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.present(.mySkillSetting)]))
    }
    
    func test_성격_타이틀을_타이핑하면_상태에_반영됩니다() {
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
    
    func test_성격_키워드을_타이핑하면_상태에_반영됩니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let personalityKeywordObserver = testScheduler.createObserver(String.self)
        _ = sut.personalityKeyword.subscribe(personalityKeywordObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typePersonalityKeyword("ㄱ")),
            .next(200, sut.typePersonalityKeyword("가")),
            .next(300, sut.typePersonalityKeyword("감")),
            .next(400, sut.typePersonalityKeyword("감ㅅ")),
            .next(500, sut.typePersonalityKeyword("감서")),
            .next(600, sut.typePersonalityKeyword("감성")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let personalityKeywords = personalityKeywordObserver.events.compactMap(\.value.element)
        expect(personalityKeywords).to(equal(["", "ㄱ", "가", "감", "감ㅅ", "감서", "감성"]))
    }
    
    func test_나의_TMI_버튼_클릭시_나의_TMI설정_화면으로_네비게이션합니다() { // given
        let testScheduler = TestScheduler(initialClock: 0)
        let navigationObserver = testScheduler.createObserver(CardCreationNavigation.self)
        _ = sut.navigation.subscribe(navigationObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.tapMyTMISetting()),
            .completed(300)
        ])
        testScheduler.start()
        
        //then
        let navigations = navigationObserver.events.compactMap(\.value.element)
        expect(navigations).to(equal([.present(.myTMISetting)]))
    }
    
    func test_About_Me를_타이핑하면_상태에_반영됩니다() {
        // given
        let testScheduler = TestScheduler(initialClock: 0)
        let aboutMeObserver = testScheduler.createObserver(String.self)
        _ = sut.aboutMe.subscribe(aboutMeObserver)
        
        // when
        _ = testScheduler.createHotObservable([
            .next(100, sut.typeAboutMe("ㅇ")),
            .next(200, sut.typeAboutMe("아")),
            .next(300, sut.typeAboutMe("안")),
            .next(400, sut.typeAboutMe("안ㄴ")),
            .next(500, sut.typeAboutMe("안녀")),
            .next(600, sut.typeAboutMe("안녕")),
            .completed(700)
        ])
        testScheduler.start()
        
        //then
        let aboutMes = aboutMeObserver.events.compactMap(\.value.element)
        expect(aboutMes).to(equal(["", "ㅇ", "아", "안", "안ㄴ", "안녀", "안녕"]))
    }
    
    func test_9() {
        
    }
    
}
