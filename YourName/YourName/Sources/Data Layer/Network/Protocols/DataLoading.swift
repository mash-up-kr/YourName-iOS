//
//  DataLoading.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

protocol DataLoader {
    @discardableResult
    func loadData(
        with urlRequestConvertible: URLRequestConvertible,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable
}
