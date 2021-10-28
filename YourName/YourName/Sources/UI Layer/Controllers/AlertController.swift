//
//  AlertController.swift
//  YourName
//
//  Created by seori on 2021/10/07.
//

import UIKit
import SnapKit
import RxSwift

struct AlertAction {
    let title: String
    let action: () -> Void
}

struct AlertModel {
    let message: String
    let actions: [AlertAction]
}

final class AlertController: ViewController {

    private var alertModel: AlertModel?
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.text = self.alertModel?.message
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = Palette.gray4
        stackView.spacing = 1
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        self.alertModel?.actions.forEach { action in
            let button = UIButton()

            button.setTitleColor(.black, for: .normal)
            button.setTitle(action.title, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.backgroundColor = .white

            button.rx.tap
                .throttle(.milliseconds(400),
                          latest: false,
                          scheduler: MainScheduler.instance)
                .bind(onNext: {
                    action.action()
                })
                .disposed(by: disposeBag)
            
            stackView.addArrangedSubviews(button)
        }
        return stackView
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = Palette.gray4
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    init(alert: AlertModel) {
        super.init()
        self.alertModel = alert
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.view.backgroundColor = Palette.gray60
        self.view.addSubviews(alertView)
        alertView.snp.makeConstraints {
            $0.height.equalTo(203)
            $0.width.equalTo(327)
            $0.center.equalToSuperview()
        }
        
        alertView.addSubviews(messageLabel, dividerView ,buttonStackView)
        
        messageLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(1)
            $0.top.equalTo(messageLabel.snp.bottom)
        }
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(63)
            $0.bottom.equalToSuperview()
        }
    }
    
    func show() {
        guard let visableViewController = UIViewController.visableViewController() else { return }
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        visableViewController.present(self, animated: true)
    }
}
