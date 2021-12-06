//
//  BackCardDetailView.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit

struct BarkCardDetailViewModel {
    let personality: String?
    let contacts: [Entity.Contact]
    let tmis: [Entity.TMI]
    let aboutMe: String?
}

final class BarkCardDetailView: UIView, NibLoadable {
    
    func configure(with viewModel: BarkCardDetailViewModel) {
        self.personalityLabel?.text = viewModel.personality
        self.aboutMeLabel?.text = viewModel.aboutMe
    }
    
    @IBOutlet private weak var contactsTableView: UITableView?
    @IBOutlet private weak var personalityLabel: UILabel?
    @IBOutlet private weak var tmisCollectionView: UICollectionView?
    @IBOutlet private weak var aboutMeLabel: UILabel?
}
