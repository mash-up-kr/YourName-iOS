//
//  SignInViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import UIKit

final class SignInViewController: ViewController {
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupAttribute() {
        self.view.backgroundColor = .systemYellow
        titleLabel.text = "Sign In"
    }
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    private let viewModel: SignInViewModel
    
    private let titleLabel = UILabel()
}
