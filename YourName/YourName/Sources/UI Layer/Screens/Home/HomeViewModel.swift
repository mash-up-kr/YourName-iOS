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
    let tabItems = BehaviorRelay<[HomeTab]>(value: HomeTab.allCases)
    let currentTab = PublishRelay<HomeTab>()
    
    func selectTab(index: Int) {
        guard let selectedTab = HomeTab(rawValue: index) else { return }
        currentTab.accept(selectedTab)
    }
}
