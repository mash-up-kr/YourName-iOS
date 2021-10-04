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
        skillStackView.subviews.forEach {
            $0.isHidden = true
        }
    }
    
    //TODO: viewModel생성 이후 수정필요
    func configureSkills(skills: [MySkillProgressView.Item]) {
        skills.enumerated().forEach { index, skill in
            guard let skillView = skillStackView.subviews[index] as? MySkillProgressView else { return }
            skillView.isHidden = false
            skillView.configureSkill(skill: skill)
        }
    }
}
