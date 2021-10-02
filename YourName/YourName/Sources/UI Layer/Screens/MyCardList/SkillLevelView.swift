//
//  SkillProgressView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit

final class SkillLevelView: UIView, NibLoadable {
    
    @IBOutlet private weak var skillTitle: UILabel!
    @IBOutlet private weak var skillStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFromNib()
        configureProgressView()
    }
    
    private func configureProgressView() {
        guard let firstView = skillStackView.subviews.first,
              let endView = skillStackView.subviews.last else { return }
        firstView.cornerRadius = firstView.bounds.height / 2
        endView.cornerRadius = firstView.bounds.height / 2
        firstView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        endView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    func configureLevel(level: Int) {
        // 받아온 레벨의 수만큼 색 변경
        for index in 0..<level {
            skillStackView.subviews[index].backgroundColor = Palette.gray3
        }
    }
}
