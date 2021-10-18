//
//  MyCardView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit

final class MyCardView: UIView, NibLoadable {
    
    @IBOutlet private weak var userProfileImage: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userRoleLabel: UILabel!
    @IBOutlet private weak var skillStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFromNib()
        configureSkill(level: 2) // 호출시점 수정필요
    }
    
    // viewModel생성 이후 수정필요
    private func configureSkill(level: Int...) {
        skillStackView.subviews.forEach { subview in
            guard let subview = subview as? SkillLevelView else { return }
            subview.configureLevel(level: level.first ?? 0)
        }
    }
}
