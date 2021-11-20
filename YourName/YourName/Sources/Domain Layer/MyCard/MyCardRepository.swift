//
//  MyCardRepository.swift
//  YourName
//
//  Created by Booung on 2021/09/21.
//

import Foundation
import RxSwift

protocol MyCardRepository {
    func fetchList() -> Observable<[NameCard]>
}
