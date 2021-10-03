//
//  ImageSourcePickerView.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit

final class ImageSourcePickerView: UIView, NibLoadable {
    
    var viewModel: ImageSourcePickerViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}
extension ImageSourcePickerView: PageSheetContentView {
    var title: String { "대표 이미지 추가하기" }
}

