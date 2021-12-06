//
//  NameCardDetail.swift
//  MEETU
//
//  Created by Booung on 2021/12/07.
//

import Foundation
import RxSwift
import RxCocoa

final class NameCardDetailViewModel {
    
    enum State {
        case front(FrontCardDetailViewModel)
        case back(BackCardDetailViewModel)
    }
    
    let state = BehaviorRelay<State?>(value: nil)
    
    func tapBack() {}
    
    func tapMore() {}
    
    func tapFrontCard() {}
    
    func tapBackCard() {}
    
}
