//
//  ImageUploadAPI.swift
//  MEETU
//
//  Created by Booung on 2021/12/01.
//

import Foundation
import Moya

struct ImageUploadAPI: ServiceAPI {
    let imageData: Data
    
    var path: String   { "/images" }
    var method: Method { .post }
    var headers: [String : String]? {
        var headers = Environment.current.network.headers
        headers["accept"] = "application/json"
        headers["content-type"] = "multipart/form-data"
        return headers
    }
    var task: NetworkingTask {
        let multipartForm = MultipartFormData(
            provider: .data(imageData),
            name: "image",
            fileName: UUID().uuidString,
            mimeType: "image/jpeg"
        )
        return .uploadMultipart([multipartForm])
    }
    
}
extension ImageUploadAPI {
    struct Response: Decodable {
        let key: String?
    }
}
