//
//  WrappedUserDefault.swift
//  OkePlayer
//
//  Created by Tomasz Lizer on 22/11/2020.
//

import Foundation

@propertyWrapper
struct WrappedUserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
