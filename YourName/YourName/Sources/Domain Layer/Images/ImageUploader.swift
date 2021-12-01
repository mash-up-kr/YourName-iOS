//
//  ImageUploader.swift
//  MEETU
//
//  Created by Booung on 2021/12/01.
//

import Foundation
import RxSwift

typealias ImageKey = String

protocol ImageUploader {
    func upload(imageData: Data) -> Observable<ImageKey>
}

final class YourNameImageUploader: ImageUploader {
    
    init(network: NetworkServing = Environment.current.network) {
        self.network = network
    }
    
    func upload(imageData: Data) -> Observable<ImageKey> {
        return self.network.request(ImageUploadAPI(imageData: imageData)).compactMap { $0.key }
    }
    
    private let network: NetworkServing
}
