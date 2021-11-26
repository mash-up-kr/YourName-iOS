//
//  QuestTableViewCell.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import UIKit

protocol QuestTableViewCellPresentable {
    var id: String? { get }
    var title: String? { get }
    var status: Quest.Status? { get }
    var rewardImageURL: String? { get }
}

final class QuestTableViewCell: UITableViewCell {
    
    func configure(with presentable: QuestTableViewCellPresentable) {
        self.titleLabel?.text = presentable.title
        if let rewardURL = URL(string: presentable.rewardImageURL ?? .empty) {
            self.rewardImageView?.setImageSource(.url(rewardURL))
        }
        switch presentable.status {
        case .wait:
            self.achieveButton?.do {
                $0.setTitle("미획득", for: .normal)
                $0.setTitleColor(Palette.gray1, for: .normal)
                $0.backgroundColor = .white
                $0.borderColor = Palette.gray1
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            }
            self.lockCoverView?.isHidden = false
        case .archieve:
            self.achieveButton?.do {
                $0.setTitle("획득하기", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.backgroundColor = Palette.black1
                $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                $0.borderColor = .black
            }
            self.lockCoverView?.isHidden = false
        case .done:
            self.achieveButton?.do {
                $0.setTitle("획득완료", for: .normal)
                $0.setTitleColor(.white, for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                $0.backgroundColor = Palette.gray1
                $0.borderColor = Palette.gray1
            }
            self.lockCoverView?.isHidden = true
        case .none: ()
        }
    }
    
    @IBOutlet private weak var rewardImageView: UIImageView?
    @IBOutlet private weak var lockCoverView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var achieveButton: UIButton?
}
