//
//  HTTPClient.swift
//  YourName
//
//  Created by Booung on 2021/09/11.
//

import Foundation
import RxSwift

public final class Network: Networking {
    
    private let dataLoader: DataLoader
    private let decodingService: Decoder
    
    init(
        dataLoader: DataLoader = HTTPClient(),
        decodingService: Decoder = JSONDecoder()
    ) {
        self.dataLoader = dataLoader
        self.decodingService = decodingService
    }
    
    public func response<Api: API> (of api: Api) -> Observable<Api.Response> {
        return Observable.create { observer in
            self.dataLoader.loadData(with: api) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    let decoded = Result {  try self.decodingService.decode(to: Api.Response.self, of: data) }
                    
                    observer.onSingleResult(decoded)
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

extension Network {
    static let shared = Network()
}
