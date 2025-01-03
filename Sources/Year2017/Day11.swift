//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day11 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        let steps = input.split(separator: ",").compactMap { HexDirection(rawValue: String($0)) }
        var position = Point.zero
        for step in steps {
            position = step.move(from: position)
        }
        
        return position.manhattanDistance(to: .zero) / 2
    }
    
    public func part2(_ input: String) -> Int {
        let steps = input.split(separator: ",").compactMap { HexDirection(rawValue: String($0)) }
        var position = Point.zero
        var furthest = 0
        for step in steps {
            position = step.move(from: position)
            furthest = max(furthest, position.manhattanDistance(to: .zero) / 2)
        }
        
        return furthest
    }
    
    enum HexDirection: String {
        case ne,nw,n,s,se,sw
        
        func move(from currentPosition: Point) -> Point {
            switch self {
            case .n: return currentPosition + Point(0,-2)
            case .s: return currentPosition + Point(0,2)
            case .ne: return currentPosition + Point(1,-1)
            case .nw: return currentPosition + Point(-1,-1)
            case .se: return currentPosition + Point(1,1)
            case .sw: return currentPosition + Point(-1,1)
            }
        }
    }
}
