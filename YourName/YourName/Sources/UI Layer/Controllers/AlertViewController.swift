//
//  AlertViewController.swift
//  MEETU
//
//  Created by 송서영 on 2021/11/07.
//

import UIKit
import RxSwift
import RxCocoa

struct AlertItem {
    struct AlertAction {
        let title: String
        let action: () -> Void
    }
    let title: String
    let message: String
    let image: UIImage
    let emphasisAction: AlertAction
    let defaultAction: AlertAction
}

final class AlertViewController: ViewController, Storyboarded {

    @IBOutlet private unowned var titleLabel: UILabel!
    @IBOutlet private unowned var messageLabel: UILabel!
    @IBOutlet private unowned var meetUImageView: UIImageView!
    @IBOutlet private unowned var emphasisButton: UIButton!
    @IBOutlet private unowned var defaultButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var item: AlertItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        self.titleLabel.text = item?.title
        self.messageLabel.text = item?.message
        self.meetUImageView.image = item?.image
        self.emphasisButton.setTitle(item?.emphasisAction.title, for: .normal)
        self.defaultButton.setTitle(item?.defaultAction.title, for: .normal)
        
        self.emphasisButton.rx.throttleTap
            .bind(onNext: { [weak self] in self?.item?.emphasisAction.action() })
            .disposed(by: disposeBag)
        
        self.defaultButton.rx.throttleTap
            .bind(onNext: { [weak self] in self?.item?.defaultAction.action() })
            .disposed(by: disposeBag)
    }
    
    func configure(item: AlertItem) {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.item = item
    }
    func dismiss(animate: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(animated: animate, completion: completion)
    }
}
