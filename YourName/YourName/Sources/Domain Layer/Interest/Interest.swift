//
//  Interest.swift
//  YourName
//
//  Created by Booung on 2021/10/07.
//

import Foundation

struct Interest: Equatable, Hashable {
    let id: Identifier
    let content: String
    let iconURL: URL
}
extension Interest {
    static let dummy: [Interest] = [Interest(id: "0", content: "๐ง ์์", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ฎ ๊ฒ์", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ผ ์์", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ช ์ด๋", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ ์์", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ฝ ์๋ฆฌ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "โ๏ธ ์นดํ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐บ ์ ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ฟ ์์ฐ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "โบ๏ธ๏ธ ์ผ์ธํ๋", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐๏ธ ๋ด์ฌ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "โ๏ธ ์ฌํ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ถ ๋๋ฌผ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ฑ ๊ธฐ์ ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ป ๊ณต์ฐ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ค ๋์ง", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ ์ผํ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐จ๏ธ ์์ ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐๏ธ ๋ทฐํฐ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ ํจ์", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐  ์ธํ๋ฆฌ์ด ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ ๋์", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ญ ๋งํ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐คฃ ๊ฐ๊ทธ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ ์๋์ฐจ", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ฃ ์ธ๊ตญ์ด", iconURL: URL(string: "www.example.com")!),
                                    Interest(id: "0", content: "๐ ๊ฒฝ์ ", iconURL: URL(string: "www.example.com")!)]
}
