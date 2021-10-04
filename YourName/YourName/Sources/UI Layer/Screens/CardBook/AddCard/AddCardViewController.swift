//
//  AddCardViewController.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit
import RxSwift
import RxCocoa

final class AddCardViewController: ViewController, Storyboarded {
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchResultEmptyView: UIView!
    @IBOutlet private weak var searchButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: AddCardViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultEmptyView.isHidden = true
        bind()
    }
    
    private func bind() {
        closeButton.rx.throttleTap
            .bind(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                // 로직 수정 필요.
                self?.searchResultEmptyView.isHidden = false
            })
            .disposed(by: disposeBag)
    }
}
