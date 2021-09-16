//
//  RootViewModekl.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import Foundation
import RxRelay
import RxSwift

final class RootViewModel {
    let currentTab = BehaviorRelay<Tab>(value: .myCards)
    
    func selectTab(index: Int) {
        guard let selectedTab = Tab(rawValue: index) else { return }
        guard selectedTab != currentTab.value else { return }
        currentTab.accept(selectedTab)
    }
}
