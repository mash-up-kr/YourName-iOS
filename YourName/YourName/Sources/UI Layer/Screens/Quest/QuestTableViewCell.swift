//
//  QuestTableViewCell.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import RxCocoa
import RxSwift
import UIKit
import Then

extension Quest: QuestTableViewCellPresentable {
    var title: String? { meta?.title }
}

protocol QuestTableViewCellPresentable {
    var title: String? { get }
    var status: Quest.Status? { get }
    var rewardImageURL: String? { get }
}

final class QuestTableViewCell: UITableViewCell {
    
    var achieveButtonDidTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.achieveButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.achieveButtonDidTap?()
            })
            .disposed(by: self.disposeBag)
    }
    
    func configure(with presentable: QuestTableViewCellPresentable) {
        self.titleLabel?.text = presentable.title
        if let rewardURL = URL(string: presentable.rewardImageURL ?? .empty) {
            self.rewardImageView?.setImageSource(.url(rewardURL))
        }
        switch presentable.status {
        case .notAchieved:
            self.achieveButton?.do {
                $0.setTitle("미획득", for: .normal)
                $0.setTitleColor(Palette.gray1, for: .normal)
                $0.backgroundColor = .white
                $0.borderColor = Palette.gray1
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            }
            self.lockCoverView?.isHidden = false
            
        case .waitingDone:
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
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var rewardImageView: UIImageView?
    @IBOutlet private weak var lockCoverView: UIView?
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var achieveButton: UIButton?
}
