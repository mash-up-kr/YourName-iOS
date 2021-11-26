//
//  CardFrontView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit
import Kingfisher
import RxSwift

final class CardFrontView: NibLoadableView {
    
    struct Item {
        let id: Int
        let image: String
        let name: String
        let role: String
        let skills: [MySkillProgressView.Item]
        let backgroundColor: ColorSource
    }
    
    @IBOutlet unowned var userProfileImage: UIImageView!
    @IBOutlet unowned var userNameLabel: UILabel!
    @IBOutlet unowned var userRoleLabel: UILabel!
    @IBOutlet unowned var skillStackView: UIStackView!
    
    private let disposeBag = DisposeBag()
    
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
        self.userProfileImage.setImageSource(.url("profile/apple.png"))
        self.userNameLabel.text = item.name
        self.userRoleLabel.text = item.role
        let gradientLayer = CAGradientLayer()
        switch item.backgroundColor {
        case .gradient(let colors):
            self.backgroundColor = nil
            gradientLayer.colors = colors.compactMap { $0.cgColor }
        case .monotone(let color):
            gradientLayer.colors = nil
            self.backgroundColor = color
        }
        self.layer.addSublayer(gradientLayer)
        self.configure(skills: item.skills)
    }
    
    func setupFlipButton(didTap: @escaping ((AddFriendCardResultView.CardState) -> Void)) {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_flip"), for: .normal)
        button.setTitle("뒷면", for: .normal)
        button.setTitleColor(Palette.gray2, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        button.rx.throttleTap
            .bind(onNext: {
                didTap(.front)
            })
            .disposed(by: disposeBag)
        
        self.contentView.addSubviews(button)
        button.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(19)
            $0.top.equalToSuperview().offset(12)
            $0.width.equalTo(52)
            $0.height.equalTo(24)
        }
    }

    //TODO: viewModel생성 이후 수정필요
    private func configure(skills: [MySkillProgressView.Item]) {
        skills.enumerated().forEach { index, skill in
            guard let skillView = skillStackView.subviews[safe: index] as? MySkillProgressView else { return }
            skillView.isHidden = false
            skillView.configure(skill: skill)
        }
    }
}
