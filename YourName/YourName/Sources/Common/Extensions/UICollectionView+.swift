//
//  UICollectionView+.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import UIKit

extension UICollectionView {
    
    func registerSectionHeaderNib<SectionHeader: UICollectionReusableView>(_ headerType: SectionHeader.Type) {
        let identifier = String(describing: headerType)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    func register<CollectionViewCell: UICollectionViewCell>(_ cellType: CollectionViewCell.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellWithReuseIdentifier: identifier)
    }
    
    func registerNib<CollectionViewCell: UICollectionViewCell>(_ cellType: CollectionViewCell.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier:  identifier)
    }
    
    func dequeueSectionHeader<SectionHeader: UICollectionReusableView>(_ headerType: SectionHeader.Type, for indexPath: IndexPath) -> SectionHeader? {
        let identifier = String(describing: headerType)
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as? SectionHeader
    }
    
    func dequeueReusableCell<CollectionViewCell: UICollectionViewCell>(_ cellType: CollectionViewCell.Type, for indexPath: IndexPath) -> CollectionViewCell? {
        let identifier = String(describing: cellType)
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CollectionViewCell
    }
    
}
