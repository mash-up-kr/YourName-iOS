//
//  SignInViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import UIKit
import RxSwift
import RxCocoa

final class WelcomeViewController: ViewController, Storyboarded {
    
    var viewModel: WelcomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch(to: viewModel)
    }
    
    private func dispatch(to: WelcomeViewModel) {
        guard let signInKakaoButton = signInKakaoButton, let signInAppleButton = signInAppleButton else { return }
        
        Observable<Provider>.merge(
            signInKakaoButton.rx.tap.map { .kakao },
            signInAppleButton.rx.tap.map { .apple }
        ).subscribe(onNext: { [weak self] provider in
            self?.viewModel.signIn(with: provider)
        }).disposed(by: disposeBag)
    }
    
    
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var signInKakaoButton: UIButton?
    @IBOutlet private weak var signInAppleButton: UIButton?
}
