//
//  MyCardView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit

final class MyCardView: UIView, NibLoadable {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRoleLabel: UILabel!
    @IBOutlet weak var skillStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFromNib()
        configureSkillProgressBar(level: 2)
    }
    // viewModel 봐서 수정필요
    private func configureSkillProgressBar(level: Int...) {
        skillStackView.subviews.forEach { subview in
            guard let subview = subview as? SkillLevelView else { return }
            subview.configureLevel(level: level.first ?? 0)
        }
    }
}
