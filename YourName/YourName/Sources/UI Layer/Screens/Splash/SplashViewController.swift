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
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let splashDuration: DispatchTimeInterval = .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) { [weak self] in
            self?.viewModel.loadAccessToken()
        }
    }
    
    override func setupAttribute() {
        self.view.backgroundColor = .systemOrange
        titleLabel.text = "Splash"
        titleLabel.textColor = .white
    }
    
    override func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(self.view)
        }
    }
    
    private let viewModel: SplashViewModel
    
    private let titleLabel = UILabel()
}
