//
//  UITableView+.swift
//  YourName
//
//  Created by Booung on 2021/09/30.
//

import UIKit

extension UITableView {
    
    func registerWithNib<TableViewCell: UITableViewCell>(_ cellType: TableViewCell.Type) {
        let nibFile = UINib(nibName: String(describing: cellType), bundle: Bundle.main)
        self.register(nibFile, forCellReuseIdentifier: String(describing: cellType))
    }
    
    func register<TableViewCell: UITableViewCell>(_ cellType: TableViewCell.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<TableViewCell: UITableViewCell>(_ cellType: TableViewCell.Type, for indexPath: IndexPath) -> TableViewCell? {
        let identifier = String(describing: cellType)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TableViewCell
    }
}
