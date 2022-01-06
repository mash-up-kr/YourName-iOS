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
    
    @IBOutlet private unowned var skillTitle: UILabel!
    @IBOutlet private unowned var skillStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configure(skillStackView: skillStackView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    private func configure(skillStackView: UIStackView) {
        guard let firstView = skillStackView.subviews.first,
              let endView = skillStackView.subviews.last else { return }
        let skillViewHeight = self.bounds.height * 0.2692
        let skillViewWidth = self.bounds.width / 10
        let firstViewBezierPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: .init(width: skillViewWidth,
                                                                               height: skillViewHeight)),
                                byRoundingCorners: [.topLeft, .bottomLeft],
                                cornerRadii: .init(width: skillViewHeight / 2,
                                                   height: skillViewHeight / 2))
        let endViewBezierPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: .init(width: skillViewWidth,
                                                                                            height: skillViewHeight)),
                                             byRoundingCorners: [.topRight, .bottomRight],
                                             cornerRadii: .init(width: skillViewHeight / 2,
                                                                height: skillViewHeight / 2))
 
        firstView.layer.mask = setupRoundCornerLayer(path: firstViewBezierPath)
        endView.layer.mask = self.setupRoundCornerLayer(path: endViewBezierPath)
    }
    
    private func setupRoundCornerLayer(path: UIBezierPath) -> CAShapeLayer {
        let maskedLayer = CAShapeLayer()
        maskedLayer.path = path.cgPath
        return maskedLayer
    }
    
    func configure(skill: MySkillProgressView.Item) {
        self.skillTitle.text = skill.title
        for index in 0..<skill.level {
            skillStackView.subviews[index].backgroundColor = Palette.gray3
        }
    }
}
