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
    
    var sampleData: Data { Data() }
}

