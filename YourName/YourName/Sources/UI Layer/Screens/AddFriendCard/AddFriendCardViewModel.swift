//
//  AddCardViewModel.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import Foundation
import RxSwift
import RxCocoa

final class AddFriendCardViewModel {
    
    enum CardState {
        case success(item: MyCardView.Item)
        case noResult
        case alreadyAdded(item: MyCardView.Item)
        case none
    }
    
    private var dummyId = ["abcd", "1234"]
    private var alreadyId = ["aaa"]
    private var addFriendCardResult = PublishRelay<CardState>()
    
    func didTapSearchButton(with id: String) {
        if dummyId.contains(id) {
            self.addFriendCardResult.accept(.success(item: .init(image: "",
                                                                 name: "성공적으로 추가됨",
                                                                 role: "역할은 서영입니다.",
                                                                 skills: [
                                                                    .init(title: "드립력", level: 3),
                                                                    .init(title: "인싸력", level: 1)
                                                                 ],
                                                                 backgroundColor: Palette.skyBlue)))
            
        }
        else if alreadyId.contains(id) {
            self.addFriendCardResult.accept(.alreadyAdded(item: .init(image: "",
                                                                 name: "이미존재하는 카드",
                                                                 role: "역할은 서영입니다.",
                                                                 skills: [
                                                                    .init(title: "드립력", level: 3)
                                                                 ],
                                                                 backgroundColor: Palette.orange)))
        }
        else {
            self.addFriendCardResult.accept(.noResult)
        }
    }
}
