//
//  SkillSettingViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import Foundation
import RxRelay
import RxSwift

protocol SkillSettingResponder: AnyObject {
    func skillSettingDidComplete(skills: [Skill])
}

final class SkillSettingViewModel {
    
    let shouldDismiss = PublishRelay<Void>()
    let canComplete = BehaviorRelay<Bool>(value: false)
    let skillsForDisplay = BehaviorRelay<[SkillInputViewModel]>(value: [.empty, .empty, .empty])
    
    init(skillSettingResponder: SkillSettingResponder) {
        self.skillSettingResponder = skillSettingResponder
        transform()
    }
    
    func typeSkillName(_ skillName: String?, at index: Int) {
        guard var updatedSkill = skillsForDisplay.value[safe: index] else { return }
        updatedSkill.title = skillName ?? .empty
        
        let updatedSkills = skillsForDisplay.value.with { $0[index] = updatedSkill }
        skillsForDisplay.accept(updatedSkills)
    }
    
    func changeSkillLevel(_ level: Int, at index: Int) {
        guard var updatedSkill = skillsForDisplay.value[safe: index] else { return }
        updatedSkill.level = level
        
        let updatedSkills = skillsForDisplay.value.with { $0[index] = updatedSkill }
        skillsForDisplay.accept(updatedSkills)
    }
    
    func tapComplete() {
        guard canComplete.value else { return }
        
        let skills = skillsForDisplay.value.map { Skill(title: $0.title, level: $0.level) }
        skillSettingResponder.skillSettingDidComplete(skills: skills)
        shouldDismiss.accept(Void())
    }
    
    private func transform() {
        skillsForDisplay.distinctUntilChanged()
            .map { skills in skills.reduce(false, { $0 || $1.title.isNotEmpty }) }
            .bind(to: canComplete)
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private let skillSettingResponder: SkillSettingResponder
}
