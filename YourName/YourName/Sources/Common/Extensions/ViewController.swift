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
        
        attribute()
        layout()
        
        #if DEBUG
        setupFLEX()
        #endif
    }
    
    func attribute() {
        fatalError("attribute() has not been implemented")
    }
    
    func layout() {
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
