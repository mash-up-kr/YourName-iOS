//
//  RootViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

final class RootViewController: ViewController {
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setupAttribute() {
        
    }
    
    override func setupLayout() {
        
    }
    
    private func bind() {
        
    }
    
    private let viewModel: RootViewModel
}
