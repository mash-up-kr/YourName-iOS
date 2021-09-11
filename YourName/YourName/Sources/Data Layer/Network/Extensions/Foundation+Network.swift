//
//  Foundation+Network.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

extension URLRequest: URLRequestConvertible {
    func asURLRequest() -> URLRequest {
        return self
    }
}

extension URL: URLRequestConvertible {
    func asURLRequest() -> URLRequest {
        return URLRequest(url: self)
    }
}

extension URLSession: Connectable {
    func dataTask(
        with urlRequestConvertible: URLRequestConvertible,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> DataTask {
        let request = urlRequestConvertible.asURLRequest()
        return dataTask(with: request, completionHandler: completionHandler)
    }
}

extension URLSessionTask: DataTask {}
