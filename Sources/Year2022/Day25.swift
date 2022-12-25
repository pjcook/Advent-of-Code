//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day25 {
    public enum Snafu: Character {
        case one = "1"
        case two = "2"
        case zero = "0"
        case minus = "-"
        case doubleMinus = "="
        
        public static let all: [Snafu] = [.two, .one, .zero, .minus, .doubleMinus]
        
        public var value: Int {
            switch self {
            case .two: return 2
            case .one: return 1
            case .zero: return 0
            case .minus: return -1
            case .doubleMinus: return -2
            }
        }
        
        public init?(_ value: Int) {
            switch value {
            case 2: self = .two
            case 1: self = .one
            case 0: self = .zero
            case -1: self = .minus
            case -2: self = .doubleMinus
            default: return nil
            }
        }
    }

    public init() {}
    
    public func part1(_ input: [String]) -> String {
        var total = 0
        
        for line in input {
            total += convert(line)
        }
        
        return convert(total)
    }
    
    public func part2(_ input: [String]) -> Int {
        return 1
    }
}

extension Day25 {
    public func convert(_ line: String) -> Int {
        var total = 0
        for (i, c) in line.enumerated() {
            let multiplier = pow(5, (line.count - i - 1))
            total += Snafu(rawValue: c)!.value * multiplier
        }
        return total
    }
    
    public func convert(_ value: Int) -> String {
        var total = Double(value)
        let topIndex = findMaxMultiplier(value) + 1
        var result = ""
        for i in (0..<topIndex) {
            let multiplier = Double(pow(5, topIndex - i - 1))
            let value = Int(round(total / multiplier))
            let snafu = Snafu(value)!
            result.append(snafu.rawValue)
            total -= Double(value) * multiplier
        }
        
        return result
    }
    
    public func findMaxMultiplier(_ value: Int) -> Int {
        var i = 1
        while true {
            let calc = pow(5, i) * 2
            if calc > value {
                return i
            }
            i += 1
        }
    }
}
