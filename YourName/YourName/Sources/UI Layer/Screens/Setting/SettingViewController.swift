//
//  ProfileViewController.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingViewController: ViewController, Storyboarded {
    
    @IBOutlet private unowned var userEmailLabel: UILabel!
    @IBOutlet private unowned var userNameLabel: UILabel!
    @IBOutlet private unowned var settingButton: UIButton!
    @IBOutlet private unowned var questView: UIView!
    @IBOutlet private unowned var questProgressView: UIProgressView!
    @IBOutlet private unowned var noticeView: UIView!
    @IBOutlet private unowned var makerView: UIView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SettingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dispatch(to: viewModel)
        bind()
    }
}

// MARK: - Method
extension SettingViewController {
    
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        questProgressView.layer.cornerRadius = 6
        questProgressView.layer.masksToBounds = true
        questProgressView.layer.sublayers![1].cornerRadius = 6
        questProgressView.subviews[1].layer.masksToBounds = true
        noticeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        makerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func dispatch(to viewModel: SettingViewModel) {
        self.rx.viewDidAppear.flatMapFirst { _ in
                self.viewModel.navigation
            }
            .bind(onNext: { [weak self] action in
                self?.navigate(action)
            })
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        settingButton.rx.tap
            .throttle(.milliseconds(400),
                      latest: false,
                      scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                self?.viewModel.tapUserSetting()
            })
            .disposed(by: disposeBag)
        
        questView.rx.tapWhenRecognized()
            .bind(onNext: { [weak self] in
                self?.viewModel.tapOnboardingQuest()
            })
            .disposed(by: disposeBag)
        
        noticeView.rx.tapWhenRecognized()
            .bind(onNext: { [weak self] in
                self?.viewModel.tapNotice()
            })
            .disposed(by: disposeBag)
        
        makerView.rx.tapWhenRecognized()
            .bind(onNext: { [weak self] in
                self?.viewModel.tapMaker()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigate(_ navigation: SettingNavigation) {
        let viewController = createViewController(navigation.destination)
        navigate(viewController, action: navigation.action)
    }
    private func createViewController(_ next: SettingDestination) -> UIViewController {
        switch next {
        case .onboardingQuest:
            // TODO: 수정필요
            return .init()
        default:
            return .init()
        }
    }
}

