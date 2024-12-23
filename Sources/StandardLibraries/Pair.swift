//
//  File.swift
//  AdventOfCode
//
//  Created by PJ on 23/12/2024.
//

import Foundation

public struct Pair<T: Hashable>: Hashable {
    public let a: T
    public let b: T
    
    public init(a: T, b: T) {
        self.a = a
        self.b = b
    }
    
    public init(_ a: T, _ b: T) {
        self.a = a
        self.b = b
    }
}
