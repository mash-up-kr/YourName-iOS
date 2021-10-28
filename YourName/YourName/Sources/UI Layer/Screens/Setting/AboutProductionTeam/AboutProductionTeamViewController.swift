//
//  AboutProductionTeamViewController.swift
//  YourName
//
//  Created by seori on 2021/10/19.
//

import UIKit
import RxSwift

final class AboutProductionTeamViewController: ViewController, Storyboarded {

    @IBOutlet unowned var naviBackButton: UIButton!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        bind()
    }
}

extension AboutProductionTeamViewController {
    func bind() {
        naviBackButton.rx.throttleTap
            .bind(onNext: { [weak self] in
                self?.closeOverlayViewControllers()
            })
            .disposed(by: disposeBag)
    }
}
