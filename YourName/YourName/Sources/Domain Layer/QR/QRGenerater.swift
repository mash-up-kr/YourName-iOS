//
//  QRGenerator.swift
//  YourName
//
//  Created by Booung on 2021/09/14.
//

import UIKit

typealias QRCode = UIImage

protocol QRGeneratable {
    func generateQR(from url: URL) -> QRCode?
}

struct QRGenerater: QRGeneratable {
    func generateQR(from url: URL) -> QRCode? {
        let data = url.absoluteString.data(using: .ascii)
        let filter = CIFilter.qrCode
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        return UIImage(ciImage: output)
    }
}

fileprivate extension CIFilter {
    static let qrCode = CIFilter(name: "CIQRCodeGenerator")!
}
