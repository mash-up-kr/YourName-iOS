//
//  TMISettingView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import UIKit

final class TMISettingView: UIView, NibLoadable {
    var viewModel: TMISettingViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
}
extension TMISettingView: PageSheetContentView {
    var title: String { "나의 TMI 입력하기" }
    var isModal: Bool { true }
}
