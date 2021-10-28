//
//  ObservableType+.swift
//  YourName
//
//  Created by seori on 2021/10/04.
//

import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
