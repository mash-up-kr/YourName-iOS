//
//  ProfileViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import SnapKit

final class ProfileViewController: ViewController {
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    override func setupAttribute() {
        self.navigationController?.navigationBar.isHidden = true
        
        let tab = Tab.profile
        self.tabBarItem = UITabBarItem(
            title: tab.description,
            image: nil,
            selectedImage: nil
        )
        
        self.view.backgroundColor = .systemPink
        titleLabel.text = "Profile"
    }
    
    private let titleLabel = UILabel()
}

