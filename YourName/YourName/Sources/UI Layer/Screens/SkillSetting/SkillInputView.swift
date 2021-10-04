//
//  SkillInputView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import UIKit
import RxSwift
import RxCocoa

final class SkillInputView: UIView, NibLoadable {
    
    var level: Int = 0 {
        didSet { configure(level: level) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        gageStackView?.clipsToBounds = true
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        gageStackView?.clipsToBounds = true
        bind()
    }
    
    private func configure(level: Int) {
        levelRelay.accept(level)
        updateUI(withLevel: level)
    }
    
    private func bind() {
        guard let levelUpButton = levelUpButton,
              let levelDownButton = levelDownButton
        else { return }
        
        Observable.merge(
            levelUpButton.rx.tap.map { +1 },
            levelDownButton.rx.tap.map { -1 }
        ).subscribe(onNext: { [weak self] changes in
            self?.level += changes
        }).disposed(by: disposeBag)
        
        levelRelay.distinctUntilChanged()
            .subscribe(onNext: { [weak self] level in
                self?.level = level
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(withLevel level: Int) {
        let activeColor = Palette.gray3
        let normalColor = Palette.lightGray3
        gageStackView?.subviews.enumerated().forEach { index, view in
            let color = index < level ? activeColor : normalColor
            view.backgroundColor = color
        }
    }
    
    private let disposeBag = DisposeBag()
    
    fileprivate let levelRelay = BehaviorRelay<Int>(value: 0)
    @IBOutlet fileprivate weak var skillNameField: UITextField?
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var gageStackView: UIStackView?
    @IBOutlet private weak var levelDownButton: UIButton?
    @IBOutlet private weak var levelUpButton: UIButton?
}
extension Reactive where Base: SkillInputView {
    
    var skillName: ControlProperty<String?>? { base.skillNameField?.rx.text }
    
    var level: BehaviorRelay<Int> { base.levelRelay }
}
