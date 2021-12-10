//
//  Notification.Name+.swift
//  MEETU
//
//  Created by seori on 2021/11/27.
//

import Foundation

extension NSNotification.Name {
    static let myCardsDidChange =     NSNotification.Name(rawValue: "myCardsDidChange")
    static let myCardDidDelete =      NSNotification.Name(rawValue: "myCardDidDelete")
    static let cardBookDidChange =    NSNotification.Name(rawValue: "cardBookDidChange")
    static let friendCardDidDelete =  NSNotification.Name(rawValue: "friendCardDidDelete")
    static let addFriendCard =        NSNotification.Name(rawValue: "addFriendCard")
}
