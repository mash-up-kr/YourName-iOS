//
//  CardFrontView.swift
//  YourName
//
//  Created by seori on 2021/10/02.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class CardFrontView: NibLoadableView {
    
    struct Item {
        let id: Identifier
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
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromNib()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupFromNib()
        self.configureUI()
    }
    
    deinit {
        print("\(String(describing: self)) deinit")
    }
}

extension CardFrontView {
    func configure(item: Item) {
        guard let url = URL(string: item.image) else { return }
        self.userProfileImage.setImageSource(.url(url))
        self.userNameLabel.text = item.name
        self.userRoleLabel.text = item.role
      
        switch item.backgroundColor {
        case .gradient(let colors):
            self.updateGradientLayer(colors: colors)
        case .monotone(let color):
            self.updateGradientLayer(colors: [color])
        }
        
        self.configure(skills: item.skills)
    }
    
    private func configureUI() {
        self.skillStackView.subviews.forEach { $0.isHidden = true }
        self.contentView.layer.cornerRadius = 12
    }
  
    private func configure(skills: [MySkillProgressView.Item]) {
        self.skillStackView.subviews.forEach { $0.isHidden = true }
        skills.enumerated().forEach { index, skill in
            guard let skillView = skillStackView.subviews[safe: index] as? MySkillProgressView else { return }
            skillView.isHidden = false
            skillView.configure(skill: skill)
        }
    }
}


// MARK: - 친구 미츄 추가하기에서 사용
extension CardFrontView {
    func setupFlipButton(didTapFlipButton: @escaping (AddFriendCardResultView.CardState) -> Void) {
        let button = UIButton().then {
            $0.setImage(UIImage(named: "icon_flip"), for: .normal)
            $0.setTitle("뒷면", for: .normal)
            $0.setTitleColor(Palette.gray2, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        }
      
        button.rx.throttleTap
            .bind(onNext: {
                didTapFlipButton(.front)
            })
            .disposed(by: disposeBag)
        
        self.contentView.addSubviews(button)
        button.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(7)
            $0.top.equalToSuperview()
            $0.width.equalTo(72)
            $0.height.equalTo(48)
        }
    }
}
