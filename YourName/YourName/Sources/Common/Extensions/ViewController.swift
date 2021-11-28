//
//  ViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import FLEX
import RxCocoa
import RxSwift
import Then
import UIKit
import Lottie
import SnapKit

class ViewController: UIViewController {
    
    let loadingIndicator = LoadingIndicator()
    
    var isLoading: Binder<Bool> {
        Binder(self) { [weak self] viewController, isLoading in
            guard let self = self else { return }
            if isLoading {
                viewController.view.bringSubviewToFront(self.loadingIndicator)
                self.loadingIndicator.isLoading = true
            } else {
                self.loadingIndicator.isLoading = false
            }
        }
    }
    
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
        self.setupLoadingIndicator()
        print(" 🐳 \(String(describing: self)) view did load")
    }
    
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
    
    private func setupLoadingIndicator() {
        self.view.addSubviews(self.loadingIndicator)
        self.loadingIndicator.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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


final class LoadingIndicator: UIView {
    
    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            isLoading ? start() : stop()
        }
    }
    
    private let animationView = AnimationView().then {
        $0.animation = Animation.named("loading")
        $0.cornerRadius = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.isHidden = true
        self.backgroundColor = UIColor(hexString: "#151515").withAlphaComponent(0.6)
        self.addSubviews(self.animationView)
        self.animationView.snp.makeConstraints {
            $0.width.height.equalTo(150)
            $0.center.equalToSuperview()
        }
    }
    
    func start() {
        self.isHidden = false
        self.animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
        self.isLoading = true
    }
    
    func stop() {
        self.isHidden = true
        self.animationView.stop()
        self.isLoading = false
    }
    
}
