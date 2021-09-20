//
//  SplashViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import UIKit

final class SplashViewController: ViewController {
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupAttribute() {}
    
    override func setupLayout() {}
    
    private let viewModel: SplashViewModel
}
