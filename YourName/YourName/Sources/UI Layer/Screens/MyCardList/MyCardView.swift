//
//  MyCardView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit

final class MyCardView: UIView, NibLoadable {
    
    @IBOutlet unowned var userProfileImage: UIImageView!
    @IBOutlet unowned var userNameLabel: UILabel!
    @IBOutlet unowned var userRoleLabel: UILabel!
    @IBOutlet unowned var skillStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFromNib()
        skillStackView.subviews.forEach {
            $0.isHidden = true
        }
    }
    
    //TODO: viewModel생성 이후 수정필요
    func configure(skills: [MySkillProgressView.Item]) {
        skills.enumerated().forEach { index, skill in
            guard let skillView = skillStackView.subviews[index] as? MySkillProgressView else { return }
            skillView.isHidden = false
            skillView.configure(skill: skill)
        }
    }
}
