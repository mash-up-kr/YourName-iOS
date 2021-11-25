//
//  YNAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Foundation
import Moya
import RxSwift

protocol ServiceAPI: TargetType {
    associatedtype Response: Decodable
    
}
extension ServiceAPI {
    
    var baseURL: URL { URL(string: "http://meetyou.co.kr")! }
    var headers: [String : String]? { Environment.current.network.headers }
    var sampleData: Data { Data() }
}

