//
//  Connectable.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

protocol Connectable {
    func dataTask(
        with urlRequestConvertible: URLRequestConvertible,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> DataTask
}
