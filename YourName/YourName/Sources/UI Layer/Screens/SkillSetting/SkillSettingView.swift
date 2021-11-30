//
//  SkillSettingView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import UIKit
import RxCocoa
import RxSwift

typealias SkillSettingViewController = PageSheetController<SkillSettingView>

final class SkillSettingView: UIView, NibLoadable {
    
    var viewModel: SkillSettingViewModel! {
        didSet { bind(to: viewModel) }
    }
    var parent: ViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    private func bind(to viewModel: SkillSettingViewModel) {
        dispatch(to: viewModel)
        render(viewModel)
    }
    
    private func dispatch(to viewModel: SkillSettingViewModel) {
        skillInputViews?.enumerated().forEach { index, view in
            view.rx.skillName?.distinctUntilChanged()
                .subscribe(onNext: { [weak self] in self?.viewModel.typeSkillName($0, at: index) })
                .disposed(by: disposeBag)
            
            view.rx.level.distinctUntilChanged()
                .subscribe(onNext: { [weak self] in self?.viewModel.changeSkillLevel($0, at: index) })
                .disposed(by: disposeBag)
        }
        
        completeButton?.rx.tap
            .subscribe(onNext: { [weak self] in self?.viewModel.tapComplete() })
            .disposed(by: disposeBag)
    }
    
    private func render(_ viewModel: SkillSettingViewModel) {
        viewModel.skillsForDisplay.distinctUntilChanged()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] skills in self?.updateUI(for: skills) })
            .disposed(by: disposeBag)
        
        if let completeButton = completeButton {
            viewModel.canComplete.distinctUntilChanged()
                .map { $0 ? Palette.black1 : Palette.gray3 }
                .observeOn(MainScheduler.asyncInstance)
                .bind(to: completeButton.rx.backgroundColor)
                .disposed(by: disposeBag)
            
            viewModel.canComplete.distinctUntilChanged()
                .bind(to: completeButton.rx.isEnabled)
                .disposed(by: disposeBag)
        }
        
    }
    
    private func updateUI(for skills: [SkillInputViewModel]) {
        skills.enumerated().forEach { index, skill in
            self.skillInputViews?[safe: index]?.skillName = skill.title
            self.skillInputViews?[safe: index]?.level = skill.level
        }
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private var skillInputViews: [SkillInputView]?
    @IBOutlet private weak var completeButton: UIButton?
    
}
extension SkillSettingView: PageSheetContentView {
    var title: String { "나의 Skill 입력하기" }
    var isModal: Bool { true }
}
