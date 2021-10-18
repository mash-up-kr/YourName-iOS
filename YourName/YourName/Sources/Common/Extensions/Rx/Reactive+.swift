//
//  Reactive+.swift
//  YourName
//
//  Created by 송서영 on 2021/10/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

extension Reactive where Base: View {
    func tapWhenRecognized() -> Observable<Void> {
        return tapGesture().when(.recognized).map { _ in return }
    }
}
