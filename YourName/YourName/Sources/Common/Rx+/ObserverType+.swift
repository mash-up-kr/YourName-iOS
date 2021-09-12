//
//  ObserverType+.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation
import RxSwift

extension ObserverType {
    func onSingleResult(_ result: Result<Element, Error>) {
        switch result {
        case .success(let element):
            self.onNext(element)
            self.onCompleted()
            
        case .failure(let error):
            self.onError(error)
        }
    }
}
