//
//  QuestViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import SnapKit

final class QuestViewController: ViewController {
    
    override func setupAttribute() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = .systemIndigo
        titleLabel.text = "Quest"
        titleLabel.textColor = .white
    }
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    
    private let titleLabel = UILabel()
}
