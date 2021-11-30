//
//  NoticeViewController.swift
//  MEETU
//
//  Created by seori on 2021/11/30.
//

import Foundation
import WebKit
import RxSwift
import RxCocoa

final class NoticeViewController: ViewController, Storyboarded {
    
    private enum Domain {
        static let notice = "https://meetu.notion.site/meetu/acb4b8fd18794d10aec5a39d2bbfcb37"
    }
 
    @IBOutlet private unowned var navigationBack: UIButton!
    @IBOutlet private unowned var webView: WKWebView!
    private let url: String = Domain.notice
    private let disposeBag = DisposeBag()
    private let loading = PublishRelay<Bool>()
    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.setupRequest(url: url)
    }
}

extension NoticeViewController {
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupRequest(url: String) {
        self.loading.accept(true)
        guard let webURL = URL(string: url) else { return }
        let request = URLRequest(url: webURL)
        
        self.webView.load(request)
        self.webView.rx.didFinishLoad
            .map { _ in return false }
            .bind(to: self.loading)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        self.navigationBack.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        self.loading
            .distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: disposeBag)
    }
}
