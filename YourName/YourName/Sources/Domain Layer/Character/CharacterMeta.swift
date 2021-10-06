//
//  CharacterMeta.swift
//  YourName
//
//  Created by Booung on 2021/10/05.
//

import Foundation

struct CharacterMeta: Equatable {
    var bodyID: String
    var eyeID: String
    var noseID: String
    var mouthID: String
    var hairAccessoryID: String?
    var etcAccesstoryID: String?
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
