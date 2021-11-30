//
//  Entity.UserOnboarding.swift
//  MEETU
//
//  Created by seori on 2021/11/21.
//

import Foundation

extension Entity {
    struct UserOnboarding: Decodable {
        enum Status: String, Decodable {
            case WAIT
            case DONE_WAIT
            case DONE
        }
        let title: String
        let status: Status
    }
}
