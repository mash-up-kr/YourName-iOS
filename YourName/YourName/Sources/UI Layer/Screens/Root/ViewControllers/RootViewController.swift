//
//  RootViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import UIKit

final class RootViewController: UITabBarController {
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: RootViewModel
}
