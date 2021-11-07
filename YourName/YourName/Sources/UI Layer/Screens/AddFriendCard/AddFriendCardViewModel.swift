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
    typealias FrontCardItem = CardFrontView.Item
    typealias BackCardItem = AddFriendCardBackView.Item
    
    enum FriendCardState {
        case success(frontCardItem: FrontCardItem,
                     backCardItem: BackCardItem)
        case noResult
        case alreadyAdded(frontCardItem: FrontCardItem,
                          backCardItem: BackCardItem)
        case none
    }
    
    private var dummyId = ["abcd", "1234"]
    private var alreadyId = ["aaa"]
    let addFriendCardResult = PublishRelay<FriendCardState>()
    
    func didTapSearchButton(with id: String) {
        if dummyId.contains(id) {
            self.addFriendCardResult.accept(.success(frontCardItem: .init(image: "",
                                                                 name: "성공적으로 추가됨",
                                                                 role: "역할은 서영입니다.",
                                                                 skills: [
                                                                    .init(title: "드립력", level: 3),
                                                                    .init(title: "인싸력", level: 1)
                                                                 ],
                                                                 backgroundColor: Palette.skyBlue),
                                                     backCardItem: .init(contacts: [ .init(image: "", type: "Email. ", value: "djm07245@gmail.com") ],
                                                                     personality: "ESTJ/모두가 날 I N 이라고하지",
                                                                     introduce: "안녕하세용!~! 반갑습니다.",
                                                                    backgroundColor: Palette.skyBlue)))
            
        }
        else if alreadyId.contains(id) {
            self.addFriendCardResult.accept(.alreadyAdded(frontCardItem: .init(image: "",
                                                                 name: "이미존재하는 카드",
                                                                 role: "역할은 서영입니다.",
                                                                 skills: [
                                                                    .init(title: "드립력", level: 3)
                                                                 ],
                                                                 backgroundColor: Palette.orange),
                                                          backCardItem: .init(contacts: [.init(image: "", type: "Facebook. ", value: "페북도 아이디가있었나.."),
                                                                                     .init(image: "", type: "Instagram. ", value: "@se0_p"),
                                                                                     .init(image: "", type: "Github. ", value: "@SongSeoYoung"),
                                                                                     .init(image: "", type: "Email. ", value: "djm07245@gmail.com"),
                                                                                     .init(image: "", type: "Phone. ", value: "010-3222-2222")],
                                                                          personality: "ESTJ/뭐엿지..",
                                                                          introduce: "하이루",
                                                                         backgroundColor: Palette.orange)))
        }
        else {
            self.addFriendCardResult.accept(.noResult)
        }
    }
}
