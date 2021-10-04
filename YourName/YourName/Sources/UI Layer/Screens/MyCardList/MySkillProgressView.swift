//
//  SkillProgressView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit

final class MySkillProgressView: UIView, NibLoadable {
    
    struct Item {
        let title: String
        let level: Int
    }
    
    @IBOutlet private weak var skillTitle: UILabel!
    @IBOutlet private weak var skillStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        configureProgressView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        configureProgressView()
    }
    
    private func configureProgressView() {
        guard let firstView = skillStackView.subviews.first,
              let endView = skillStackView.subviews.last else { return }
        firstView.cornerRadius = (self.bounds.height * 0.26) / 2
        endView.cornerRadius = (self.bounds.height * 0.26) / 2
        firstView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        endView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    func configureSkill(skill: MySkillProgressView.Item) {
        skillTitle.text = skill.title
        for index in 0..<skill.level {
            skillStackView.subviews[index].backgroundColor = Palette.gray3
        }
    }
}
