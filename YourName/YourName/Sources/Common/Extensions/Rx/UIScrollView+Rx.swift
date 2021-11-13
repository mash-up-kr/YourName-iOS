//
//  UIScrollView+Rx.swift
//  MEETU
//
//  Created by Booung on 2021/11/13.
//

import RxOptional
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {
    
    var contentSize: Observable<CGSize> {
        self.base.rx.observe(CGSize.self, "contentSize").filterNil()
    }
}
