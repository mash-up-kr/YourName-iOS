//
//  SettingViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/09.
//

import Foundation
import RxSwift
import RxCocoa

enum SettingDestination: Equatable {
    case userSetting
    case onboardingQuest
    case notice
    case aboutProductionTeam
    case logout
}

typealias SettingNavigation = Navigation<SettingDestination>

final class SettingViewModel {
    let navigation = PublishRelay<SettingNavigation>()
    let backToFirst = PublishRelay<Void>()   // 네이밍.. 모르겠어요 추천받습니다.
    let isLoading = PublishRelay<Bool>()
    let alert = PublishRelay<AlertViewController>()
    
    private let authRepository: AuthenticationRepository
    private let disposeBag = DisposeBag()
    
    init(authRepository: AuthenticationRepository) {
        self.authRepository = authRepository
        self.bind()
    }
    
    deinit {
        print(" 💀 \(String(describing: self))")
    }
    
    // MARK: - Methods
    
    func tapOnboardingQuest() {
        self.navigation.accept(.present(.onboardingQuest))
    }
    func tapNotice() {
        self.navigation.accept(.push(.notice))
    }
    func tapAboutProductionTeam() {
        self.navigation.accept(.push(.aboutProductionTeam))
    }
    
    func tapLogOut() {
        self.isLoading.accept(true)
        self.authRepository.logout()
            .do { [weak self] _ in
                self?.isLoading.accept(false)
            }
            .catchError({ error in
                //TODO:
                print(error)
                return .empty()
            })
            .bind(to: self.backToFirst)
            .disposed(by: self.disposeBag)
    }
    
    func tapResign() {
        
        let alertController = AlertViewController.instantiate()
        let resignAction = { [weak self] in
            guard let self = self else { return }
            
            alertController.dismiss(animated: true)
            self.isLoading.accept(true)
            self.authRepository.resign()
                .do { [weak self] _ in
                    self?.isLoading.accept(false)
                }
                .catchError { error in
                    print(error)
                    return .empty()
                }
                .bind(to: self.backToFirst)
                .disposed(by: self.disposeBag)
        }
        
        let cancelAction = {
            alertController.dismiss(animated: true)
        }
        alertController.configure(item: AlertItem(title: "정말 탈퇴하시겠츄?",
                                                  message: "나의 모든 미츄 카드와 정보가 삭제되며\n귀여운 미츄를 더 이상 만날 수 없어요",
                                                  image: UIImage(named: "resign_meetu")!,
                                                  emphasisAction: .init(title: "탈퇴하기", action: resignAction),
                                                  defaultAction: .init(title: "탈퇴 안할래요", action: cancelAction)))
        self.alert.accept(alertController)
    }
}

extension SettingViewModel {

    private func bind() {
        self.backToFirst
            .bind(onNext: {
                UserDefaults.standard.delete(.accessToken)
                UserDefaults.standard.delete(.refreshToken)
            })
            .disposed(by: disposeBag)
    }
}
