//
//  AddFriendCardViewController.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit
import RxSwift
import RxCocoa

final class AddFriendCardViewController: ViewController, Storyboarded {
    
    @IBOutlet private unowned var searchTextField: UITextField!
    @IBOutlet private unowned var searchResultEmptyView: UIView!
    @IBOutlet private unowned var searchButton: UIButton!
    @IBOutlet private unowned var backButton: UIButton!
    @IBOutlet private unowned var addButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: AddFriendCardViewModel!
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
}

extension AddFriendCardViewController {
    
    private func configureUI() {
        searchResultEmptyView.isHidden = true
        addButton.isHidden = true
        self.searchTextField.becomeFirstResponder()
    }
    
    private func bind() {
        
        Observable.merge(
            searchTextField.rx.controlEvent([.editingDidEndOnExit])
                .mapToVoid(),
            searchResultEmptyView.rx.tapWhenRecognized()
                .mapToVoid()
            )
            .bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        
        searchButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                // TODO: 로직 수정 필요.
                // 검색하기전 -> searchResultEmptyView.isHidden = true
                // 검색 후 ->
                //  ㄴ 1. 검색결과 존재 -> 카드 디테일화면 + 추가하기 버튼
                //  ㄴ 2. 검색결과 존재 X -> searchResultEmptyView.isHidden = false
                self?.searchResultEmptyView.isHidden = false
            })
            .disposed(by: disposeBag)
    }
}
