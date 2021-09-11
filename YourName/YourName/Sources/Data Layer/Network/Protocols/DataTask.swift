//
//  DataTask.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

protocol Resumable {
    func resume()
}

protocol Cancellable {
    func cancel()
}

typealias DataTask = Resumable & Cancellable
