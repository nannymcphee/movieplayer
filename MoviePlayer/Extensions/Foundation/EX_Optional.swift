//
//  EX_Optional.swift
//  JJMTest
//
//  Created by Nguyên Duy on 8/1/19.
//  Copyright © 2019 Nguyên Duy. All rights reserved.
//

import Foundation

import Foundation

extension Optional {
    public func or(other: Wrapped) -> Wrapped {
        if let ret = self {
            return ret
        } else {
            return other
        }
    }
}

extension Optional where Wrapped == [String: Any] {
    public func orEmpty() -> [String: Any] {
        return self.or(other: [:])
    }
}

extension Optional where Wrapped == String {
    public func orEmpty() -> String {
        return self.or(other: "")
    }
}

extension Optional where Wrapped == Double {
    public func orEmpty() -> Double {
        return self.or(other: 0.0)
    }
}

extension Optional where Wrapped == Int {
    public func orEmpty() -> Int {
        return self.or(other: 0)
    }
}

extension Optional where Wrapped == Bool {
    public func orFalse() -> Bool {
        return self.or(other: false)
    }
}

extension Optional where Wrapped == Date {
    public func orEmpty() -> Date {
        return self.or(other: Date())
    }
}

extension Optional where Wrapped == NSNumber {
    public func orEmpty() -> NSNumber {
        return self.or(other: 0)
    }
}

