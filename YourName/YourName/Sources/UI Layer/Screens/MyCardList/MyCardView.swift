//
//  MyCardView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit
import Kingfisher

final class MyCardView: NibLoadableView {
    
    struct Item {
        let image: String
        let name: String
        let role: String
        let skills: [MySkillProgressView.Item]
        let backgroundColor: UIColor
    }
    
    @IBOutlet unowned var userProfileImage: UIImageView!
    @IBOutlet unowned var userNameLabel: UILabel!
    @IBOutlet unowned var userRoleLabel: UILabel!
    @IBOutlet unowned var skillStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        configureUI()
    }
    
    private func configureUI() {
        skillStackView.subviews.forEach {
            $0.isHidden = true
        }
        contentView.layer.cornerRadius = 12
    }
    
    func configure(item: Item) {
        self.userNameLabel.text = item.name
        self.userRoleLabel.text = item.role
        self.contentView.backgroundColor = item.backgroundColor
        self.configure(skills: item.skills)
    }
    
    //TODO: viewModel생성 이후 수정필요
    private func configure(skills: [MySkillProgressView.Item]) {
        skills.enumerated().forEach { index, skill in
            guard let skillView = skillStackView.subviews[index] as? MySkillProgressView else { return }
            skillView.isHidden = false
            skillView.configure(skill: skill)
        }
    }
}
