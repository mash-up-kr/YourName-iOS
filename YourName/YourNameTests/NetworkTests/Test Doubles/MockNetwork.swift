//
//  MockHTTPClient.swift
//  AppStoreTests
//
//  Created by dongyoung.lee on 2021/03/24.
//

@testable import YourName
import RxSwift
import Foundation

enum StubResponse {
    case data(Any)
    case error(Error)
}

final class MockNetwork: Network {
    
    var calledRequest = false
    var stubbedApiResponse: StubResponse?
    
    func response<Api>(of api: Api) -> Observable<Api.Response> where Api : API {
        guard let stubbedApiResponse = stubbedApiResponse else {
            fatalError("Stubed Api Response did not configured" )
        }
        switch stubbedApiResponse {
        case .data(let response): return Observable<Api.Response>.just(response as! Api.Response)
        case .error(let error): return .error(error)
        }
    }
    
}
