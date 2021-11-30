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
    private(set) var navigation = PublishRelay<SettingNavigation>()
    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
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
    
    func tapLogOut() -> Observable<Void> {
        guard let accessToken = UserDefaultManager.accessToken else { return .empty() }
        return self.authRepository.requestLogout(accessToken: accessToken)
            .catchError({ error in
                //TODO:
                print(error)
                return .empty()
            })
            .flatMap({ () -> Observable<Void> in
                UserDefaultManager.accessToken = nil
                UserDefaultManager.refreshToken = nil
                return Observable<Void>.create { observer in
                    observer.onNext(())
                    observer.onCompleted()
                    
                    return Disposables.create()
                }
            })
    }
    func tapResign() {
        // TODO: API가 안나온듯하다~
    }
}
