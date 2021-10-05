//
//  CharacterMeta.swift
//  YourName
//
//  Created by Booung on 2021/10/05.
//

import Foundation

struct CharacterMeta: Equatable {
    let bodyID: String
    let eyeID: String
    let noseID: String
    let mouthID: String
    let hairAccessoryID: String?
    let etcAccesstoryID: String?
}
extension CharacterMeta {
    static let `default` = CharacterMeta(
        bodyID: "body_1",
        eyeID: "eye_1",
        noseID: "nose_1",
        mouthID: "mouth_1",
        hairAccessoryID: nil,
        etcAccesstoryID: nil
    )
}
