//
//  CardDetailViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import UIKit

final class CardDetailViewController: ViewController {
    
    init(viewModel: CardDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupAttribute() {
        self.view.backgroundColor = .systemIndigo
        titleLabel.text = "Card Detail"
        titleLabel.textColor = .black
    }
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    private let viewModel: CardDetailViewModel
    
    private let titleLabel = UILabel()
}
