//
//  MockRouter.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/21.
//

@testable import YourName
import Foundation

final class MockDataLoader: DataLoader {
    var calledLoadData = false
    var completedURLs: [URL] = []
    var stubedData: Data?
    var stubedStatusCode: Int = 200
    var stubedError: Error?
    
    func loadData(
        with urlRequestConvertible: URLRequestConvertible,
        completionHandler: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable {
        calledLoadData = true
        let url = urlRequestConvertible.asURLRequest().url!
        let dataTask = MockDataTask(
            url: url,
            completionHandler: { data, _, _ in
                if let data = data {
                    completionHandler(.success(data))
                }
            }
        )
        self.completedURLs.append(url)
        dataTask.whenCompletion(
            data: stubedData,
            statusCode: stubedStatusCode,
            error: stubedError
        )
        return dataTask
    }
}
