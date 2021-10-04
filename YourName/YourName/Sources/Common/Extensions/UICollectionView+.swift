//
//  UICollectionView+.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import UIKit

extension UICollectionView {
    
    func registerWithNib<CollectionViewCell: UICollectionViewCell>(_ cellType: CollectionViewCell.Type) {
        let nibFile = UINib(nibName: String(describing: cellType), bundle: Bundle.main)
        self.register(nibFile, forCellWithReuseIdentifier: String(describing: cellType))
    }
    func register<CollectionViewCell: UICollectionViewCell>(_ cellType: CollectionViewCell.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<CollectionViewCell: UICollectionViewCell>(_ cellType: CollectionViewCell.Type, for indexPath: IndexPath) -> CollectionViewCell? {
        let identifier = String(describing: cellType)
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CollectionViewCell
    }
    
}
