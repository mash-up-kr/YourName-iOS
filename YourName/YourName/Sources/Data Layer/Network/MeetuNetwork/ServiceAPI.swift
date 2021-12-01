//
//  YNAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation
import Moya
import RxSwift
import RxOptional

protocol ServiceAPI: TargetType {
    associatedtype Response: Decodable
    
    var task: NetworkingTask { get }
}
extension ServiceAPI {
    
    var baseURL: URL { URL(string: "https://meetyou.co.kr")! }
    var headers: [String : String]? { Environment.current.network.headers }
    var task: Moya.Task { task }
    var sampleData: Data { Data() }
}

