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
        self.rewardImageView?.setImageSource(.url(presentable.rewardImageURL ?? .empty))
        switch presentable.status {
        case .wait:
            self.lockCoverView?.isHidden = false
        case .archieve:
            self.lockCoverView?.isHidden = false
        case .done:
            self.lockCoverView?.isHidden = true
        case .none: ()
        }
    }
    
    @IBOutlet private weak var rewardImageView: UIImageView?
    @IBOutlet private weak var lockCoverView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var achieveButton: UIButton?
}
