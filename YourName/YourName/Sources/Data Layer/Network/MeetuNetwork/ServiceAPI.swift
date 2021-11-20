//
//  YNAPI.swift
//  MEETU
//
//  Created by Booung on 2021/11/20.
//

import Moya
import Foundation

protocol ServiceAPI: TargetType {
    associatedtype Response: Decodable
    
}

import RxSwift
