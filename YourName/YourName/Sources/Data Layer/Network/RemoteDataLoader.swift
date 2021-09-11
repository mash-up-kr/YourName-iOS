//
//  DataLoader.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation

final class RemoteDataLoader: DataLoader {
    
    private let session: Connectable
    
    init(session: Connectable = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    func loadData(
        with urlRequestConvertible: URLRequestConvertible,
        completionHandler: @escaping (Result<Data, Error>) -> Void = { _ in }
    ) -> Cancellable {
        let task = session.dataTask(with: urlRequestConvertible) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               400..<500 ~= httpResponse.statusCode {
                completionHandler(.failure(HTTPError.client))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               500..<600 ~= httpResponse.statusCode {
                completionHandler(.failure(HTTPError.server))
                return
            }
            guard let data = data else {
                completionHandler(.failure(HTTPError.noData))
                return
            }
            completionHandler(.success(data))
        }
        
        task.resume()
        
        return task
    }
}



