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
        
    }
    
    override func setupLayout() {
        
    }
    
    private let viewModel: CardDetailViewModel
}
