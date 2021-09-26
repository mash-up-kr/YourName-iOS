//
//  Tab.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import Foundation
import UIKit

enum HomeTab: Int, CaseIterable {
    case myCardList
    case cardBook
    case setting
    case create
}
extension HomeTab: CustomStringConvertible {
    var description: String {
        switch self {
        case .myCardList: return "내 명함"
        case .cardBook: return "도감"
        case .setting: return "기타 설정"
        case .create: return ""
        }
    }
}
extension HomeTab {
    var activeIcon: UIImage? {
        switch self {
        case .myCardList: return UIImage(named: "icon_mycard_active")
        case .cardBook: return UIImage(named: "icon_cardbook_active")
        case .setting: return UIImage(named: "icon_hamburger_active")
        case .create: return nil
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .myCardList: return UIImage(named: "icon_mycard")
        case .cardBook: return UIImage(named: "icon_cardbook")
        case .setting: return UIImage(named: "icon_hamburger")
        case .create: return nil
        }
    }
}
extension HomeTab {
    func asTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: description,
            image: icon,
            selectedImage: activeIcon
        )
    }
}
