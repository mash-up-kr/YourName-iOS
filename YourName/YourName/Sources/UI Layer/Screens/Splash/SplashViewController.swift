//
//  SplashViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import UIKit

final class SplashViewController: ViewController, Storyboarded {
    
    var viewModel: SplashViewModel!
    
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
    
}
