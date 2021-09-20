//
//  RootViewModekl.swift
//  YourName
//
//  Created by Booung on 2021/09/10.
//

import Foundation
import RxRelay
import RxSwift

struct HomeViewModel {
    let tabItems = BehaviorRelay<[Tab]>(value: Tab.allCases)
    let currentTab = PublishRelay<Tab>()
    
    func selectTab(index: Int) {
        guard let selectedTab = Tab(rawValue: index) else { return }
        currentTab.accept(selectedTab)
    }
}
