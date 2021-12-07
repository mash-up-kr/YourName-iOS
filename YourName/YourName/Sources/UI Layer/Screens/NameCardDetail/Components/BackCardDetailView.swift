//
//  BackCardDetailView.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit

struct BackCardDetailViewModel {
    let personality: String?
    let contacts: [Entity.Contact]
    let tmis: [Entity.TMI]
    let aboutMe: String?
    let backgroundColor: ColorSource
}

final class BackCardDetailView: NibLoadableView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    func configure(with viewModel: BackCardDetailViewModel) {
        self.personalityLabel?.text = viewModel.personality
        self.aboutMeLabel?.text = viewModel.aboutMe
        self.contentView.setColorSource(viewModel.backgroundColor)
    }
    
    @IBOutlet private weak var contactsTableView: UITableView?
    @IBOutlet private weak var personalityLabel: UILabel?
    @IBOutlet private weak var tmisCollectionView: UICollectionView?
    @IBOutlet private weak var aboutMeLabel: UILabel?
}
