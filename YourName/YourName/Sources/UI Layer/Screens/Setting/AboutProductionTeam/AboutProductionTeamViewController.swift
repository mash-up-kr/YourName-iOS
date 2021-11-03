//
//  AboutProductionTeamViewController.swift
//  YourName
//
//  Created by seori on 2021/10/19.
//

import UIKit
import RxSwift

final class AboutProductionTeamViewController: ViewController, Storyboarded {

    @IBOutlet private unowned var naviBackButton: UIButton!
    private let disposeBag = DisposeBag()
    override var hidesBottomBarWhenPushed: Bool {
        get {
          return navigationController?.topViewController == self
        }
        set {
          super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension AboutProductionTeamViewController {
    func bind() {
        self.naviBackButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.closeOverlayViewControllers()
            })
            .disposed(by: disposeBag)
    }
}
