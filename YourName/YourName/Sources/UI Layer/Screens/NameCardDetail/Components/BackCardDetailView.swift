//
//  BackCardDetailView.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import UIKit
import RxSwift

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
        self.setupUI()
    }
    
    func configure(with viewModel: BackCardDetailViewModel) {
        self.personalityLabel?.text = viewModel.personality
        self.aboutMeLabel?.text = viewModel.aboutMe
        self.contacts = viewModel.contacts
        self.contactsTableView?.reloadData()
        self.tmis = viewModel.tmis
        self.tmisCollectionView?.reloadData()
        self.layoutIfNeeded()
        self.scrollView?.setColorSource(viewModel.backgroundColor)
    }
    
    private func setupUI() {
        self.contactsTableView?.registerWithNib(CardDetailContactTableViewCell.self)
        self.contactsTableView?.allowsSelection = false
        self.contactsTableView?.dataSource = self
        
        self.contactsTableView?.rx.contentSize
            .subscribe(onNext: { [weak self] contentSize in
                self?.contactTableViewHeight?.constant = contentSize.height
            })
            .disposed(by: self.disposeBag)
        
        self.tmisCollectionView?.registerWithNib(CardDetailTMICollectionViewCell.self)
        self.tmisCollectionView?.delegate = self
        self.tmisCollectionView?.dataSource = self
        if let collectionViewLayout = self.tmisCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        self.tmisCollectionView?.rx.contentSize
            .subscribe(onNext: { [weak self] contentSize in
                self?.tmisCollectionViewHeight?.constant = contentSize.height
            })
            .disposed(by: self.disposeBag)
    }
    
    private var contacts: [Entity.Contact] = []
    private var tmis: [Entity.TMI] = []
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private(set) weak var scrollView: UIScrollView?
    @IBOutlet private weak var contactsTableView: UITableView?
    @IBOutlet private weak var contactTableViewHeight: NSLayoutConstraint?
    @IBOutlet private weak var personalityLabel: UILabel?
    @IBOutlet private weak var tmisCollectionView: UICollectionView?
    @IBOutlet private weak var tmisCollectionViewHeight: NSLayoutConstraint?
    @IBOutlet private weak var aboutMeLabel: UILabel?
}
extension BackCardDetailView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(CardDetailContactTableViewCell.self, for: indexPath),
              let contact = contacts[safe: indexPath.row] else { return UITableViewCell() }
        
        cell.configure(with: contact)
        return cell
    }
    
}
extension BackCardDetailView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tmis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(CardDetailTMICollectionViewCell.self, for: indexPath),
              let tmi = self.tmis[safe: indexPath.item] else { return UICollectionViewCell() }
        
        cell.configure(with: tmi)
        return cell
    }
    
}
extension BackCardDetailView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
}
