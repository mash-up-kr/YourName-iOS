//
//  PageSheetController.swift
//  YourName
//
//  Created by Booung on 2021/10/02.
//

import RxCocoa
import RxSwift
import UIKit
import FLEX

protocol PageSheetContentView: UIView {
    var title: String { get }
    var isModal: Bool { get }
}

final class PageSheetController<ContentView: PageSheetContentView>: ViewController {
    let contentView: ContentView
    var onDismiss: ((ContentView) -> Void)?
    
    init(contentView: ContentView) {
        self.contentView = contentView
        super.init()
        self.titleLabel.text = contentView.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupContentView(contentView: contentView)
        bind()
    }
    
    func show() {
        guard let visableViewController = UIViewController.visableViewController() else { return }
        self.modalPresentationStyle = .overFullScreen
        let dimmedView = UIView().then { $0.backgroundColor = Palette.black1.withAlphaComponent(0.6) }
        visableViewController.view.addSubview(dimmedView)
        dimmedView.frame = visableViewController.view.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak dimmedView] in
            dimmedView?.removeFromSuperview()
        })
        visableViewController.present(self, animated: false, completion: nil)
    }
    
    func close() {
        self.dismiss(animated: false, completion: {
            self.onDismiss?(self.contentView)
        })
    }
    
    private func configureUI() {
        self.view.backgroundColor = Palette.black1.withAlphaComponent(0.6)
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        stackView.addArrangedSubviews(topBarView)
        topBarView.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        topBarView.backgroundColor = .white
        topBarView.clipsToBounds = true
        topBarView.addSubviews(closeButton, titleLabel)
        topBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topBarView.layer.cornerRadius = 20
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        closeButton.setImage(UIImage(named: "btn_close")!, for: .normal)
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.leading.equalToSuperview().offset(18)
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        self.view.rx.tapGesture()
            .when(.recognized)
            .filter { [weak self] _ in (self?.contentView.isModal).isFalseOrNil }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.close()
            })
            .disposed(by: disposeBag)
        
        self.closeButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.close()
        })
        .disposed(by: disposeBag)
        
        #if DEBUG
        self.contentView.rx.tapGesture()
            .when(.recognized)
            .filter { $0.numberOfTapsRequired > 2 }
            .subscribe(onNext: { _ in
                FLEXManager.shared.showExplorer()
            })
            .disposed(by: disposeBag)
        #endif
    }
    
    private func setupContentView(contentView: ContentView) {
        stackView.addArrangedSubview(contentView)
    }

    private func removeContentView(contentView: ContentView) {
        stackView.removeArrangedSubview(contentView)
        contentView.removeFromSuperview()
    }
    
    private let stackView = UIStackView().then { $0.axis = .vertical }
    private let topBarView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let disposeBag = DisposeBag()
}
