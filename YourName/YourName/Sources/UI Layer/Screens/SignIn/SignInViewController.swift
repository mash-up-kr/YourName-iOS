//
//  SignInViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class SignInViewController: ViewController {
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupAttribute() {
        
    }
    
    override func setupLayout() {
        
    }
    
    private let viewModel: SignInViewModel
}
