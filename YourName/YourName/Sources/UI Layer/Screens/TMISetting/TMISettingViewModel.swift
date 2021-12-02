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
    
    let interestsForDisplay = BehaviorRelay<[TMIContentCellViewModel]>(value: [])
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
            .bind(to: interests)
            .disposed(by: disposeBag)
        
        strongPointRepository.fetchAll().debug()
            .bind(to: strongPoints)
            .disposed(by: disposeBag)
    }
    
    private func transform() {
        interests.map { list in
            list.map { TMIContentCellViewModel(id: $0.id, isSelected: false, content: $0.content, imageSource: .url($0.iconURL)) }
        }.bind(to: interestsForDisplay)
        .disposed(by: disposeBag)
        
        strongPoints.map { list in
            list.map { TMIContentCellViewModel(id: $0.id, isSelected: false, content: $0.content, imageSource: .url($0.iconURL)) }
        }.bind(to: strongPointsForDisplay)
        .disposed(by: disposeBag)
    }
    
    func tapInterest(at index: Int) {
        guard let selectedInterest = self.interests.value[safe: index] else { return }
        
        self.selectedInterests.toggle(selectedInterest)
        if self.selectedInterests.count > 3 { self.selectedInterests.removeFirst() }
        self.mutateInterestViewModels()
    }
    
    func tapStrongPoint(at index: Int) {
        guard let selectedStrongPoint = self.strongPoints.value[safe: index] else { return }
        
        self.selectedStrongPoints.toggle(selectedStrongPoint)
        
        if self.selectedStrongPoints.count > 3 { self.selectedStrongPoints.removeFirst() }
        self.mutateStrongPointViewModels()
    }
    
    func tapComplete() {
        let interests = self.selectedInterests.asArray()
        let strongPoints = self.selectedStrongPoints.asArray()
        
        tmiSettingResponder.tmiSettingDidComplete(interests: interests, strongPoints: strongPoints)
    }
    
    private func mutateInterestViewModels() {
        let interestsForDisplay = self.interestsForDisplay.value
        let updatedInterests = interestsForDisplay.map { interestViewModel -> TMIContentCellViewModel in
            var interestViewModel = interestViewModel
            interestViewModel.isSelected = self.selectedInterests.contains(where: { $0.id == interestViewModel.id })
            return interestViewModel
        }
        self.interestsForDisplay.accept(updatedInterests)
    }
    
    private func mutateStrongPointViewModels() {
        let strongPointsForDisplay = self.strongPointsForDisplay.value
        let updatedStrongPoints = strongPointsForDisplay.map { strongPointViewModel -> TMIContentCellViewModel in
            var strongPointViewModel = strongPointViewModel
            strongPointViewModel.isSelected = self.selectedStrongPoints.contains(where: { $0.id == strongPointViewModel.id })
            return strongPointViewModel
        }
        self.strongPointsForDisplay.accept(updatedStrongPoints)
    }
    
    private let disposeBag = DisposeBag()
    
    private let interests = BehaviorRelay<[Interest]>(value: [])
    private let strongPoints = BehaviorRelay<[StrongPoint]>(value: [])
    
    private var selectedInterests = OrderedSet<Interest>()
    private var selectedStrongPoints = OrderedSet<StrongPoint>()
    
    private let interestRepository: InterestRepository
    private let strongPointRepository: StrongPointRepository
    private let tmiSettingResponder: TMISettingResponder
}
