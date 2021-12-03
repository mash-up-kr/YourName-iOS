//
//  String+.swift
//  YourName
//
//  Created by Booung on 2021/09/18.
//

import Foundation

extension String {
    static let empty = ""
}

extension String {
    subscript(_ index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    subscript(safe index: Int) -> Character? {
        guard index >= 0 else { return nil }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    subscript(range: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        let range: Range<Index> = start..<end
        return String(self[range])
    }
    
    subscript(safe range: Range<Int>) -> String {
        let start: String.Index = {
            if range.lowerBound < self.count {
                return self.index(self.startIndex, offsetBy: range.lowerBound)
            } else {
                return self.startIndex
            }
        }()
        let end: String.Index = {
            if range.upperBound < self.count {
                return self.index(self.startIndex, offsetBy: range.upperBound)
            } else {
                return self.endIndex
            }
        }()
        let range: Range<Index> = start..<end
        return String(self[range])
    }
    
    subscript(range: NSRange) -> String {
        if range.length <= 0 { return "" }
        let startIndex = range.location
        let endIndex = range.location + range.length
        return self[startIndex..<endIndex]
    }
}

extension String {
    func toBinary() -> String? {
        guard var number = Int(self) else { return nil }
        var binary = ""
        while number > 2 {
            binary.insert(contentsOf: "\(number % 2)", at: startIndex)
            number /= 2
        }
        binary.insert(contentsOf: "\(number)", at: startIndex)
        return binary
    }
}
