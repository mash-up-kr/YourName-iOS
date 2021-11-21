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
    var tapWhenRecognized: ControlEvent<Void> {
        let source = tapGesture().when(.recognized).mapToVoid()
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIButton {
    var throttleTap: ControlEvent<Void> {
        let source = tap
            .throttle(.milliseconds(400),
                      latest: false,
                      scheduler: MainScheduler.instance)
        return ControlEvent(events: source)
    }
}
