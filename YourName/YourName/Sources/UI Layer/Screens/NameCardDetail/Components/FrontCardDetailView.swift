//
//  FrontCardDetailView.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit

protocol FrontCardDetailViewDelegate: AnyObject {
    func frontCardDetailView(_ frontCardDetailView: FrontCardDetailView, didTapCopy uniqueCode: UniqueCode)
}

struct FrontCardDetailViewModel {
    let uniqueCode: UniqueCode?
    let profileImageSource: ImageSource?
    let name: String?
    let role: String?
    let skills: [MySkillProgressView.Item]
    let backgroundColor: ColorSource
}

final class FrontCardDetailView: NibLoadableView {
    
    weak var delegate: FrontCardDetailViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bubbleViewDidTap))
        self.bubbleView?.addGestureRecognizer(tapGesture)
    }
    
    func configure(with viewModel: FrontCardDetailViewModel) {
        self.profileImageView?.setImageSource(viewModel.profileImageSource)
        self.cardIDLabel?.text = "#\(viewModel.uniqueCode ?? .empty)"
        self.nameLabel?.text = viewModel.name
        self.roleLabel?.text = viewModel.role
        self.uniqueCode = viewModel.uniqueCode
        self.scrollView?.setColorSource(viewModel.backgroundColor)
        self.skillViews?.enumerated().forEach { index, view in
            guard let skill = viewModel.skills[safe: index] else { return view.isHidden = true }
            view.isHidden = false
            view.configure(skill: skill)
        }
    }
    
    @objc private func bubbleViewDidTap() {
        guard let uniqueCode = self.uniqueCode else { return }
        
        delegate?.frontCardDetailView(self, didTapCopy: uniqueCode)
    }
    
    private var uniqueCode: UniqueCode?
    
    @IBOutlet private(set) weak var scrollView: UIScrollView?
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var bubbleView: UIView?
    @IBOutlet private weak var cardIDLabel: UILabel?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var roleLabel: UILabel?
    @IBOutlet private var skillViews: [MySkillProgressView]?
}

