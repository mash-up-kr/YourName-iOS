//
//  PageSheetController.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import RxCocoa
import RxSwift
import UIKit

final class PageSheetController<ContentView: UIView>: ViewController {
    
    var titleText: String?
    var titleImage: UIImage?
    var canClos: Bool = false
    let contentView: ContentView
    
    init(contentView: ContentView) {
        self.contentView = contentView
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupContentView(contentView: contentView)
    }
    
    private func configureUI() {
        self.view.backgroundColor = Palette.black1.withAlphaComponent(0.6)
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        stackView.addArrangedSubviews(topBarView)
        topBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        topBarView.addSubviews(closeButton, titleLabel)
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupContentView(contentView: ContentView) {
        stackView.addArrangedSubview(contentView)
    }

    private func removeContentView(contentView: ContentView) {
        stackView.removeArrangedSubview(contentView)
        contentView.removeFromSuperview()
    }
    
    private let stackView = UIStackView().then { $0.axis = .vertical }
    private let topBarView = UIView().then { $0.backgroundColor = .red }
    private let titleLabel = UILabel().then { $0.backgroundColor = .blue }
    private let closeButton = UIButton().then { $0.backgroundColor = .yellow }
    private let disposeBag = DisposeBag()
}
