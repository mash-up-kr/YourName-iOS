//
//  SkillSettingView.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import UIKit

typealias SkillSettingViewController = PageSheetController<SkillSettingView>

final class SkillSettingView: UIView, NibLoadable {
    
    var viewModel: SkillSettingViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
}
extension SkillSettingView: PageSheetContentView {
    var title: String { "나의 Skill 입력하기" }
    var isModal: Bool { true }
}
