//
//  CardBookViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import SnapKit

final class CardBookViewController: ViewController {
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    override func setupAttribute() {
        let tab = Tab.cardBook
        self.tabBarItem = UITabBarItem(
            title: tab.description,
            image: nil,
            selectedImage: nil
        )
        
        self.view.backgroundColor = .systemGreen
        titleLabel.text = "Card Book"
        titleLabel.textColor = .black
    }
    
    private let titleLabel = UILabel()
}
