//
//  AddCardViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import RxSwift
import RxCocoa

struct DummyAddCardItem {
    var name: String
    var role: String
}

final class AddFriendCardViewModel {
    
    enum CardState {
        case success(item: DummyAddCardItem)
        case noResult
        case alreadyAdded(item: DummyAddCardItem)
        case none
    }
    
    var dummyId = ["abcd", "1234"]
    var alreadyId = ["aaa"]
    var addFriendCardResult = PublishRelay<CardState>()
    
    func didTapSearchButton(with id: String) {
        if dummyId.contains(id) {
            self.addFriendCardResult.accept(.success(item: .init(name: "서영", role: "롤")))
            
        }
        else if alreadyId.contains(id) {
            self.addFriendCardResult.accept(.alreadyAdded(item: .init(name: "서영", role: "롤")))
        }
        else {
            self.addFriendCardResult.accept(.noResult)
        }
    }
}
