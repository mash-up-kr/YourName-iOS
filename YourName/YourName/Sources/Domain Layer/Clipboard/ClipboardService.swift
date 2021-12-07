//
//  ClipboardService.swift
//  MEETU
//
//  Created by Booung on 2021/12/08.
//

import Foundation
import UIKit

protocol ClipboardService {
    func copy(_ text: String)
}

final class YourNameClipboardService: ClipboardService {
    func copy(_ text: String) {
        UIPasteboard.general.string = text
    }
}
