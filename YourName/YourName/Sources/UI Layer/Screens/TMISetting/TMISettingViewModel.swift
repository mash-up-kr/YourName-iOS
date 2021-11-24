//
//  TMISettingViewModel.swift
//  YourName
//
//  Created by Booung on 2021/10/04.
//

import Foundation
import RxRelay
import RxSwift

protocol TMISettingResponder {
    func tmiSettingDidComplete(interests: [Interest], strongPoints: [StrongPoint])
}

final class TMISettingViewModel {
    
    let interestesForDisplay = BehaviorRelay<[TMIContentCellViewModel]>(value: [])
    let strongPointsForDisplay = BehaviorRelay<[TMIContentCellViewModel]>(value: [])
    
    init(
        interestRepository: InterestRepository,
        strongPointRepository: StrongPointRepository,
        tmiSettingResponder: TMISettingResponder
    ) {
        self.interestRepository = interestRepository
        self.strongPointRepository = strongPointRepository
        self.tmiSettingResponder = tmiSettingResponder
        
        transform()
    }
    
    func didLoad() {
        interestRepository.fetchAll()
            .bind(to: interestes)
            .disposed(by: disposeBag)
        
        strongPointRepository.fetchAll()
            .bind(to: strongPoints)
            .disposed(by: disposeBag)
    }
    
    private func transform() {
        interestes.map { list in
            list.map { TMIContentCellViewModel(isSelected: false, content: $0.content) }
        }.bind(to: interestesForDisplay)
        .disposed(by: disposeBag)
        
        strongPoints.map { list in
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
    
    func tapComplete() {
        let selectedInterestes = interestesForDisplay.value
            .enumerated()
            .filter { $0.element.isSelected }
            .compactMap { self.interestes.value[safe: $0.offset] }
        let selectedStrongPoints = strongPointsForDisplay.value
            .enumerated()
            .filter { $0.element.isSelected }
            .compactMap { self.strongPoints.value[safe: $0.offset] }
        
        tmiSettingResponder.tmiSettingDidComplete(interests: selectedInterestes, strongPoints: selectedStrongPoints)
    }
    
    private let disposeBag = DisposeBag()
    
    private let interestes = BehaviorRelay<[Interest]>(value: [])
    private let strongPoints = BehaviorRelay<[StrongPoint]>(value: [])
    
    private let interestRepository: InterestRepository
    private let strongPointRepository: StrongPointRepository
    private let tmiSettingResponder: TMISettingResponder
}
