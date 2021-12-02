//
//  Set+.swift
//  MEETU
//
//  Created by Booung on 2021/11/25.
//

import Foundation
import RxSwift

extension Set {
    mutating func toggle(_ member: Element) {
        if self.contains(member) {
            self.remove(member)
        } else {
            self.insert(member)
        }
    }
}

struct OrderedSet<Element: Hashable> {
    
    private var innerSet = NSMutableOrderedSet()
    
    var first: Element? { return self.innerSet.firstObject as? Element }
    var count: Int { self.innerSet.count }
    
    mutating func toggle(_ element: Element) {
        if self.contains(element) {
            self.remove(element)
        } else {
            self.append(element)
        }
    }
    
    func contains(_ element: Element) -> Bool {
        return innerSet.contains(element)
    }
    
    func append(_ element: Element) {
        self.innerSet.add(element)
    }
    
    func insert(_ element: Element, at index: Int) {
        self.innerSet.insert(element, at: index)
    }
    
    func remove(_ element: Element) {
        self.innerSet.remove(element)
    }
    
    func remove(at index: Int) {
        self.innerSet.removeObject(at: index)
    }
    
    func removeFirst() {
        guard innerSet.count > 0 else { return }
        self.innerSet.removeObject(at: 0)
    }
    
    func index(of element: Element) -> Int? {
        guard innerSet.contains(element) else { return nil }
        return self.innerSet.index(of: element)
    }
    
    func asArray() -> [Element] {
        return self.innerSet.array.compactMap { $0 as? Element }
    }
}
