//
//  LocalStorage.swift
//  MEETU
//
//  Created by Booung on 2021/12/01.
//

import Foundation
import RxSwift

enum PersistanceKey: String {
    case accessToken
    case refreshToken
}

protocol LocalStorage {
    func read<T>(_ key: PersistanceKey) -> Observable<T?>
    func write<T>(_ key: PersistanceKey, value: T) -> Observable<Bool>
    func delete(_ key: PersistanceKey) -> Observable<Bool>
}

extension UserDefaults: LocalStorage {
    #warning("수정이 필요해용")
    func read<T>(_ key: PersistanceKey) -> Observable<T?> {
        let value = self.object(forKey: key.rawValue) as? T
        return .just(value)
    }
    
    func write<T>(_ key: PersistanceKey, value: T) -> Observable<Bool> {
        self.setValue(value, forKey: key.rawValue)
        return .just(true)
    }
    
    func delete(_ key: PersistanceKey) -> Observable<Bool> {
        self.removeObject(forKey: key.rawValue)
        return .just(true)
    }
}
