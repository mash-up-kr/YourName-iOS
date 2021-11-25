//
//  Entity.Login.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

extension Entity {
    struct Login: Decodable {
        let accessToken: String?
        let refreshToken: String?
        let userOnboarding: [Quest]?
    }
}
