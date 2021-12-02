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
    
    @IBOutlet private unowned var questNotiView: UIView!
    @IBOutlet private unowned var resignButton: UIButton!
    @IBOutlet private unowned var logoutButton: UIButton!
    @IBOutlet private unowned var questView: UIView!
    @IBOutlet private unowned var noticeView: UIView!
    @IBOutlet private unowned var aboutProductionTeamView: UIView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SettingViewModel!
    var aboutProductionTeamFactory: (() -> AboutProductionTeamViewController)!
    var questViewControllerFactory: (() -> QuestViewController)!
    var noticeViewControllerFactory: (() -> NoticeViewController)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bind()
        self.dispatch(to: viewModel)
        self.render(viewModel)
    }
}

// MARK: - Method

extension SettingViewController {
    
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.noticeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.aboutProductionTeamView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func dispatch(to viewModel: SettingViewModel) {
        self.rx.viewDidAppear
            .flatMapFirst ({ [weak self] _ -> Observable<SettingNavigation> in
                guard let self = self else { return .empty() }
                return self.viewModel.navigation.asObservable()
            })
            .bind(onNext: { [weak self] action in
                self?.navigate(action)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func render(_ viewModel: SettingViewModel) {
        
        viewModel.isLoading
            .distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        
        viewModel.backToFirst
            .bind(onNext: {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = RootDependencyContainer().createRootViewController()
            })
            .disposed(by: self.disposeBag)
        
        viewModel.alert
            .bind(onNext: { [weak self] in
                self?.present($0, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        
        self.questView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.tapOnboardingQuest()
            })
            .disposed(by: self.disposeBag)
        
        self.noticeView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.tapNotice()
            })
            .disposed(by: self.disposeBag)
        
        self.aboutProductionTeamView.rx.tapWhenRecognized
            .bind(onNext: { [weak self] in
                self?.viewModel.tapAboutProductionTeam()
            })
            .disposed(by: self.disposeBag)
        
        self.logoutButton.rx.throttleTap
            .asObservable()
            .bind(onNext: { [weak self] in
                self?.viewModel.tapLogOut()
            })
            .disposed(by: self.disposeBag)
        
        self.resignButton.rx.throttleTap
            .bind (onNext:{ [weak self] in
                self?.viewModel.tapResign()
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Navigation
extension SettingViewController {
    private func navigate(_ navigation: SettingNavigation) {
        let viewController = createViewController(navigation.destination)
        self.navigate(viewController, action: navigation.action)
    }
    private func createViewController(_ next: SettingDestination) -> UIViewController {
        switch next {
        case .onboardingQuest:
            return self.questViewControllerFactory()
        case .aboutProductionTeam:
            return self.aboutProductionTeamFactory()
        case .notice:
            return self.noticeViewControllerFactory()
        default:
            return .init()
        }
    }
}

