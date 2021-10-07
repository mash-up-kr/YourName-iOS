//
//  TMISettingViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import Foundation
import RxRelay
import RxSwift

final class TMISettingViewModel {
    
    let interestes = BehaviorRelay<[Interest]>(value: [])
    let personalities = BehaviorRelay<[Personality]>(value: [])
    
    init(
        interestRepository: InterestRepository,
        personalityRepository: PersonalityRepository
    ) {
        self.interestRepository = interestRepository
        self.personalityRepository = personalityRepository
    }
    
    func didLoad() {
        interestRepository.fetchAll()
            .bind(to: interestes)
            .disposed(by: disposeBag)
        
        personalityRepository.fetchAll()
            .bind(to: personalities)
            .disposed(by: disposeBag)
    }
    
    private let disposeBag = DisposeBag()
    
    private let interestRepository: InterestRepository
    private let personalityRepository: PersonalityRepository
}
