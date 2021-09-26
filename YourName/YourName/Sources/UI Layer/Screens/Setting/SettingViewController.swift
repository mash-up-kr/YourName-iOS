//
//  ProfileViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import SnapKit

final class SettingViewController: ViewController {
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    override func setupAttribute() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = .systemPink
        titleLabel.text = "Setting"
    }
    
    private let titleLabel = UILabel()
}

