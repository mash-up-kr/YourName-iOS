//
//  ImageSourcePickerView.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit

typealias ImageSourceTypePickerViewController = PageSheetController<ImageSourceTypePickerView>

final class ImageSourceTypePickerView: UIView, NibLoadable {
    
    var viewModel: ImageSourceTypePickerViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}
extension ImageSourceTypePickerView: PageSheetContentView {
    var title: String { "대표 이미지 추가하기" }
    var isModal: Bool { false }
}

