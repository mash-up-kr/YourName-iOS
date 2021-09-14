//
//  ViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import FLEX
import RxSwift
import Then
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttribute()
        setupLayout()
        #if DEBUG
        setupFLEX()
        #endif
    }
    
    
    /// set up attribute(property) of subviews
    ///
    ///     textLabel.text = "Hello, world"
    ///     textLabel.textColor = .systemBlue
    func setupAttribute() {
        fatalError("attribute() has not been implemented")
    }
    
    /// set up layout of subviews
    ///
    ///
    ///       view.addSubview(textLabel)
    ///       textLabel.translatesAutoresizingMaskIntoConstraints = false
    ///       NSLayoutConstraint.activate([
    ///           textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ///           textLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ///       ])
    func setupLayout() {
        fatalError("layout() has not been implemented")
    }
}
// MARK: - FLEX Tool
#if DEBUG
extension ViewController {
    private func setupFLEX() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activateFLEX)).then {
            $0.numberOfTouchesRequired = 4
        }
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func activateFLEX() {
        FLEXManager.shared.showExplorer()
    }
}
#endif
