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
    var questViewControllerFactory: (() -> QuestViewController)!
    var noticeViewControllerFactory: (() -> NoticeViewController)!
    
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
        
        questView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.tapOnboardingQuest()
            })
            .disposed(by: disposeBag)
        
        noticeView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.tapNotice()
            })
            .disposed(by: disposeBag)
        
        aboutProductionTeamView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.tapAboutProductionTeam()
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.throttleTap
            .asObservable()
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.viewModel.tapLogOut()
            }
            .bind(onNext: {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = RootDependencyContainer().createRootViewController()
            })
            .disposed(by: disposeBag)
        
        resignButton.rx.throttleTap
            .bind (onNext:{ [weak self] in
                self?.viewModel.tapResign()
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
            return questViewControllerFactory()
        case .aboutProductionTeam:
            return aboutProductionTeamFactory()
        case .notice:
            return noticeViewControllerFactory()
        default:
            return .init()
        }
    }
}

