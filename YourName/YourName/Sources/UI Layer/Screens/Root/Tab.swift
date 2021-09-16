//
//  Tab.swift
//  YourName
//
//  Created by Booung on 2021/09/17.
//

import Foundation

enum Tab: Int, CaseIterable {
    case home
    case cardBook
    case quest
    case profile
}
extension Tab: CustomStringConvertible {
    var description: String {
        switch self {
        case .home: return "리스트"
        case .cardBook: return "도감"
        case .quest: return "퀘스트"
        case .profile: return "프로필"
        }
    }
}
