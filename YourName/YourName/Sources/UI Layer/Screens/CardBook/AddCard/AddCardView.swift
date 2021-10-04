//
//  AddCardView.swift
//  YourName
//
//  Created by seori on 2021/10/03.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxGesture

typealias AddCardViewController = PageSheetController<AddCardView>

final class AddCardView: UIView, NibLoadable {
    
    private enum Constant {
        static let modalTitle = "도감 추가하기"
    }
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchResultEmptyView: UIView!
    @IBOutlet private weak var searchButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var viewModel: AddCardViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        configureEmptyResultView()
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}

extension AddCardView: PageSheetContentView {
    var title: String { Constant.modalTitle }
    var isModal: Bool { true }
}

extension AddCardView {
    
    private func configureEmptyResultView() {
        self.searchResultEmptyView.snp.makeConstraints {
            let deviceHeight = UIScreen.main.bounds.height
            let topSpacing = 44
            let topContentHeight = 132
            $0.height.equalTo(Int(deviceHeight) - topSpacing - topContentHeight)
        }
        searchResultEmptyView.isHidden = true
    }
    
    private func bind() {
        
        Observable.merge(
            searchTextField.rx.controlEvent([.editingDidEndOnExit])
                .mapToVoid(),
            searchResultEmptyView.rx.tapGesture()
                .when(.recognized)
                .mapToVoid()
        )
            .bind(onNext: { [weak self] _ in
                self?.endEditing(true)
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
