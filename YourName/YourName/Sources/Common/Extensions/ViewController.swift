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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print(" 🐣 \(String(describing: self)) init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print(" 🐣 \(String(describing: self)) init")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" 🐳 \(String(describing: self)) view did load")
        
        #if DEBUG
        setupFLEX()
        #endif
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
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
