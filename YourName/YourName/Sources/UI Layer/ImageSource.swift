//
//  ImageSource.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import UIKit

enum ImageSource: Equatable {
    case image(UIImage)
    case url(URL)
    case data(Data)
}
