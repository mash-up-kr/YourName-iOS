//
//  HomeViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import SnapKit

final class MyCardListViewController: ViewController {
    
    init(viewModel: MyCardListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    override func setupAttribute() {
        let tab = Tab.myCardList
        self.tabBarItem = UITabBarItem(
            title: tab.description,
            image: nil,
            selectedImage: nil
        )
        
        self.view.backgroundColor = .systemBlue
        titleLabel.text = "MyCardList"
        
    }
    
    private let viewModel: MyCardListViewModel
    
    private let titleLabel = UILabel()
}
