//
//  PaletteView.swift
//  YourName
//
//  Created by Booung on 2021/10/03.
//

import UIKit

typealias PaletteViewController = PageSheetController<PaletteView>

final class PaletteView: UIView, NibLoadable {
    var viewModel: PaletteViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    @IBOutlet private weak var colorsCollectionView: UICollectionView?
    @IBOutlet private weak var completeButton: UIButton?
}
extension PaletteView: PageSheetContentView {
    var title: String { "배경 컬러 선택하기" }
    var isModal: Bool { false }
}
//extension PaletteView: UICollectionViewDataSource {
//
//}
//extension PaletteView: UICollectionViewDelegateFlowLayout {
//
//}
