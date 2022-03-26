//
//  CardBookMoreView.swift
//  MEETU
//
//  Created by Seori on 2022/03/26.
//

import UIKit
import RxSwift
import RxCocoa

typealias CardBookMoreViewController = PageSheetController<CardBookMoreView>

final class CardBookMoreView: UIView, NibLoadable {
    
    @IBOutlet private unowned var memeberStackView: UIStackView!
    @IBOutlet private unowned var editStackView: UIStackView!
    @IBOutlet private unowned var addMemberView: UIView!
    @IBOutlet private unowned var deleteMemberView: UIView!
    @IBOutlet private unowned var cardBookEditView: UIView!
    @IBOutlet private unowned var cardBookDeleteView: UIView!
    @IBOutlet private unowned var cardBookDeleteLabel: UILabel!
    
    var parent: ViewController?
    private var viewModel: CardBookMoreViewModel!
    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupFromNib()
        
        self.bind()
        self.configureUI()
    }
    
    convenience init(viewModel: CardBookMoreViewModel,
                     parent: ViewController?) {
        self.init(frame: .zero)
        self.viewModel = viewModel
        self.parent = parent
        self.bind()
        self.configureUI()
    }
    deinit {
        print(" 💀 \(String(describing: self)) deinit")
    }
}

extension CardBookMoreView {
    func configureUI() {
        editStackView.cornerRadius = 12
        memeberStackView.cornerRadius = 12
        editStackView.clipsToBounds = true
        memeberStackView.clipsToBounds = true
    }
    func bind() {
        
    }
}

// MARK: - PageSheetContentView

extension CardBookMoreView: PageSheetContentView {
    var title: String { "" }
    var isModal: Bool { true }
}
