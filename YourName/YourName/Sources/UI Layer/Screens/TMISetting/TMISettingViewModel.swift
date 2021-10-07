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
    
    let interestesForDisplay = BehaviorRelay<[TMIContentCellViewModel]>(value: [])
    let strongPointsForDisplay = BehaviorRelay<[TMIContentCellViewModel]>(value: [])
    
    init(
        interestRepository: InterestRepository,
        strongPointRepository: StrongPointRepository
    ) {
        self.interestRepository = interestRepository
        self.strongPointRepository = strongPointRepository
        
        transform()
    }
    
    func didLoad() {
        interestRepository.fetchAll()
            .bind(to: interestes)
            .disposed(by: disposeBag)
        
        strongPointRepository.fetchAll()
            .bind(to: personalities)
            .disposed(by: disposeBag)
    }
    
    private func transform() {
        interestes.map { list in
            list.map { TMIContentCellViewModel(isSelected: false, content: $0.content) }
        }.bind(to: interestesForDisplay)
        .disposed(by: disposeBag)
        
        personalities.map { list in
            list.map { TMIContentCellViewModel(isSelected: false, content: $0.content) }
        }.bind(to: strongPointsForDisplay)
        .disposed(by: disposeBag)
    }
    
    func tapInterest(at index: Int) {
        guard var selectedInterest = interestesForDisplay.value[safe: index] else { return }
        selectedInterest.isSelected.toggle()
        
        let updateInterestes = interestesForDisplay.value.with { $0[index] = selectedInterest }
        interestesForDisplay.accept(updateInterestes)
    }
    
    func tapPersonality(at index: Int) {
        guard var selectedPersonality = strongPointsForDisplay.value[safe: index] else { return }
        selectedPersonality.isSelected.toggle()
        
        let updatedPersonalities = strongPointsForDisplay.value.with { $0[index] = selectedPersonality }
        strongPointsForDisplay.accept(updatedPersonalities)
    }
    
    private let disposeBag = DisposeBag()
    
    private let interestes = BehaviorRelay<[Interest]>(value: [])
    private let personalities = BehaviorRelay<[StrongPoint]>(value: [])
    
    private let interestRepository: InterestRepository
    private let strongPointRepository: StrongPointRepository
}
