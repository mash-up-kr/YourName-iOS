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
    
    @IBOutlet private unowned var resignButton: UIButton!
    @IBOutlet private unowned var logoutButton: UIButton!
    @IBOutlet private unowned var questView: UIView!
    @IBOutlet private unowned var questProgressView: UIProgressView!
    @IBOutlet private unowned var noticeView: UIView!
    @IBOutlet private unowned var aboutProductionTeamView: UIView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SettingViewModel!
    var aboutProductionTeamFactory: (() -> AboutProductionTeamViewController)!
    
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
        aboutProductionTeamView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
        
        aboutProductionTeamView.rx.tapWhenRecognized()
            .bind(onNext: { [weak self] in
                self?.viewModel.tapAboutProductionTeam()
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .throttle(.microseconds(400),
                      latest: false,
                      scheduler: MainScheduler.instance)
            .bind(onNext: {
                print("logout")
            })
            .disposed(by: disposeBag)
        
        resignButton.rx.tap
            .throttle(.microseconds(400),
                      latest: false,
                      scheduler: MainScheduler.instance)
            .bind (onNext:{
                print("탈퇴하기")
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
        case .aboutProductionTeam:
            return aboutProductionTeamFactory()
        default:
            return .init()
        }
    }
}

