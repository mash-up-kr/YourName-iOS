//
//  StrongPoint.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct StrongPoint: Equatable, Hashable {
    let id: Identifier
    let content: String
    let iconURL: URL
}
extension StrongPoint {
    static let dummy: [StrongPoint] = [StrongPoint(id: "0", content: "β λ¦¬λμ½", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π₯ μ΄μ ", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π΅ λκΈ°", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "πΌ λ°°λ €", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "πͺ μΆμ§λ ₯", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π€ μμ κ°", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π μ±μκ°", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π μΉνλ ₯", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π λ°νμ", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π» μ μλ ₯", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π κΌΌκΌΌν¨", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π¬ μν΅", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "π κΈμ μ ", iconURL: URL(string: "www.example.com")!),
                                       StrongPoint(id: "0", content: "β‘ μμ΄λμ΄", iconURL: URL(string: "www.example.com")!)]
}
