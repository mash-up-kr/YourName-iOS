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
    var onComplete: (() -> Void)? { get }
}
extension PageSheetContentView {
    var onComplete: (() -> Void)? { nil }
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
        let dimmedColor = Palette.black1.withAlphaComponent(0.6)
        if let underlaiedViewController = self.presentingViewController {
            let overlaiedViewController = self
            let dimmedView = UIView().then {
                $0.layer.shouldRasterize = true
                $0.backgroundColor = Palette.black1.withAlphaComponent(0.6)
                $0.frame = underlaiedViewController.view.bounds
            }
            overlaiedViewController.view.backgroundColor = .clear
            underlaiedViewController.view.addSubview(dimmedView)
            self.dismiss(animated: true, completion: { [weak dimmedView, weak overlaiedViewController] in
                dimmedView?.removeFromSuperview()
                overlaiedViewController?.view.backgroundColor = dimmedColor
                self.onDismiss?(self.contentView)
            })
        } else {
            self.dismiss(animated: true, completion: {
                self.onDismiss?(self.contentView)
            })
        }
    }
    
    private func configureUI() {
        
        backgroundView.backgroundColor = .clear
        self.view.addSubviews(backgroundView, stackView)
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(stackView.snp.top)
        }
        
        self.view.backgroundColor = Palette.black1.withAlphaComponent(0.6)
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { $0.leading.trailing.bottom.equalToSuperview() }
        stackView.addArrangedSubviews(topBarView)
        
        topBarView.snp.makeConstraints { $0.height.equalTo(64) }
        topBarView.backgroundColor = .white
        topBarView.clipsToBounds = true
        topBarView.addSubviews(closeButton, titleLabel, completeButton)
        topBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topBarView.layer.cornerRadius = 20
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.setImage(UIImage(named: "btn_close")!, for: .normal)
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.leading.equalToSuperview().offset(18)
            $0.centerY.equalToSuperview()
        }
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(Palette.black1, for: .normal)
        completeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        completeButton.isHidden = contentView.onComplete == nil
    }
    
    private func bind() {
        if contentView.isModal == false {
            self.backgroundView.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in self?.close() })
                .disposed(by: disposeBag)
        }
        
        self.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in self?.close() })
            .disposed(by: disposeBag)
        
        self.completeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.contentView.onComplete?()
                self?.close()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupContentView(contentView: ContentView) {
        stackView.addArrangedSubview(contentView)
    }
    
    private func removeContentView(contentView: ContentView) {
        stackView.removeArrangedSubview(contentView)
        contentView.removeFromSuperview()
    }
    
    private let backgroundView = UIView()
    private let stackView = UIStackView().then { $0.axis = .vertical }
    private let topBarView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let completeButton = UIButton()
    private let disposeBag = DisposeBag()
}
