//
//  ImageSourcePickerView.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit
import RxCocoa
import RxSwift

typealias ImageSourceTypePickerViewController = PageSheetController<ImageSourceTypePickerView>

final class ImageSourceTypePickerView: UIView, NibLoadable {
    
    var viewModel: ImageSourceTypePickerViewModel! {
        didSet {
            dispatch(to: viewModel)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    private func dispatch(to viewModel: ImageSourceTypePickerViewModel) {
        photoButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapPhotoButton()
            })
            .disposed(by: disposeBag)
        
        characterButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tapCreateCharacterButton()
            })
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var photoButton: UIButton?
    @IBOutlet private weak var characterButton: UIButton?
}
extension ImageSourceTypePickerView: PageSheetContentView {
    var title: String { "대표 이미지 추가하기" }
    var isModal: Bool { false }
}

