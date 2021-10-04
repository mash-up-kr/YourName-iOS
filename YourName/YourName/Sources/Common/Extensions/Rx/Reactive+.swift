//
//  Reactive+.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {
    var throttleTap: ControlEvent<Void> {
        let source = tap
            .throttle(
                .milliseconds(400),
                latest: false,
                scheduler: MainScheduler.instance
            )
        return ControlEvent(events: source)
    }
}
