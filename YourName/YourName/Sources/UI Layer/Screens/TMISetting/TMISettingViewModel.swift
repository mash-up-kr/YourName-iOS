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
        interestRepository.fetchAll().debug("")
            .bind(to: interestes)
            .disposed(by: disposeBag)
        
        strongPointRepository.fetchAll().debug()
            .bind(to: strongPoints)
            .disposed(by: disposeBag)
    }
    
    private func transform() {
        interestes.map { list in
            list.map { TMIContentCellViewModel(isSelected: false, content: $0.content, imageSource: .url($0.iconURL)) }
        }.bind(to: interestesForDisplay)
        .disposed(by: disposeBag)
        
        strongPoints.map { list in
            list.map { TMIContentCellViewModel(isSelected: false, content: $0.content, imageSource: .url($0.iconURL)) }
        }.bind(to: strongPointsForDisplay)
        .disposed(by: disposeBag)
    }
    
    func tapInterest(at index: Int) {
        guard let selectedInterest = self.interestes.value[safe: index] else { return }
        guard var selectedInteresteForDisplay = self.interestesForDisplay.value[safe: index] else { return }
        
        selectedInterestes.toggle(selectedInterest)
        selectedInteresteForDisplay.isSelected.toggle()
        let updateInterestes = self.interestesForDisplay.value.with { $0[index] = selectedInteresteForDisplay }
        self.interestesForDisplay.accept(updateInterestes)
    }
    
    func tapPersonality(at index: Int) {
        guard let selectedStrongPoint = self.strongPoints.value[safe: index] else { return }
        guard var selectedStrongPointForDisplay = self.strongPointsForDisplay.value[safe: index] else { return }
        
        self.selectedStrongPoints.toggle(selectedStrongPoint)
        selectedStrongPointForDisplay.isSelected.toggle()
        let updateStrongPoints = self.strongPointsForDisplay.value.with { $0[index] = selectedStrongPointForDisplay }
        self.strongPointsForDisplay.accept(updateStrongPoints)
    }
    
    func tapComplete() {
        let interests = Array(self.selectedInterestes)
        let strongPoints = Array(self.selectedStrongPoints)
        
        tmiSettingResponder.tmiSettingDidComplete(interests: interests, strongPoints: strongPoints)
    }
    
    private let disposeBag = DisposeBag()
    
    private let interestes = BehaviorRelay<[Interest]>(value: [])
    private let strongPoints = BehaviorRelay<[StrongPoint]>(value: [])
    
    private var selectedInterestes = Set<Interest>()
    private var selectedStrongPoints = Set<StrongPoint>()
    
    private let interestRepository: InterestRepository
    private let strongPointRepository: StrongPointRepository
    private let tmiSettingResponder: TMISettingResponder
}
