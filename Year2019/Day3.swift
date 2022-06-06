//
//  Day3.swift
//  Year2019
//
//  Created by PJ COOK on 03/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import InputReader

public struct ManhattanInstruction {
    public enum Direction: String {
        case R,L,U,D
    }
    
    public let direction: Direction
    public let distance: Int
    
    public init(_ value: String) throws {
        var value = value
        guard
            let direction = Direction(rawValue: String(value.removeFirst())),
            let distance = Int(value)
        else {
            throw Errors.invalidManhattanInstruction
        }
        self.direction = direction
        self.distance = distance
    }
}

public struct GridRef: Hashable {
    public let x: Int
    public let y: Int
}

public struct WireData {
    public struct DirectionRange {
        public let up: Int
        public let down: Int
        public let left: Int
        public let right: Int
        
        public init(up: Int, down: Int, left: Int, right: Int) {
            self.up = up
            self.down = down
            self.left = left
            self.right = right
        }
        
        public var maxX: Int { return left + right + 1 }
        public var maxY: Int { return up + down + 1 }
        public var origin: GridRef {
            return GridRef(x: left, y: up)
        }
        
        public func maxRange(_ range: DirectionRange) -> DirectionRange {
            return DirectionRange(
                up: max(up, range.up),
                down: max(down, range.down),
                left: max(left, range.left),
                right: max(right, range.right)
            )
        }
        
        public static let zero = DirectionRange(up: 0, down: 0, left: 0, right: 0)
    }
    
    public let data: [ManhattanInstruction]
    public let range: DirectionRange
    
    public init(_ input: String) throws {
        data = try input.split(separator: ",").compactMap { try ManhattanInstruction(String($0))}
        range = Self.calculateRange(data)
    }
    
    public static func calculateRange(_ data: [ManhattanInstruction]) -> DirectionRange {
        var up = 0
        var down = 0
        var left = 0
        var right = 0
        
        var x = 0
        var y = 0
        
        _ = data.map {
            switch $0.direction {
                case .U:
                    y += $0.distance
                    if y > up { up = y }
                case .D:
                    y -= $0.distance
                    if y < down { down = y }
                case .L:
                    x -= $0.distance
                    if x < left { left = x }
                case .R:
                    x += $0.distance
                    if x > right { right = x }
            }
        }
        
        return DirectionRange(
            up: abs(up),
            down: abs(down),
            left: abs(left),
            right: abs(right)
        )
    }
}

public struct ManhattanMap {
    private var points = [GridRef:Int]()
    private let range: WireData.DirectionRange
    private let columns: Int
    private let rows: Int
    private var wireData = [WireData]()
    
    public init(_ range: WireData.DirectionRange) {
        columns = range.maxX
        rows = range.maxY
        self.range = range
    }
    
    public func minManhattanDistance() -> Int? {
        var distance = Int.max
        let lineCount = wireData.count
        
        for item in points where item.value == lineCount {
            let x = item.key.x < range.origin.x ? range.origin.x - item.key.x : item.key.x - range.origin.x
            let y = item.key.y < range.origin.y ? range.origin.y - item.key.y : item.key.y - range.origin.y
            let value = x + y
            if value < distance {
                distance = value
            }
        }
        
        return distance
    }
    
    public func fewestSteps() -> Int? {
        var steps = [Int]()
        let lineCount = wireData.count
        for item in points where item.value == lineCount {
            var count = 0
            for data in wireData {
                count += plot(data, to: item.key)
            }
            steps.append(count)
        }
        
        return steps.sorted().first
    }
    
    public func plot(_ data: WireData, to point: GridRef) -> Int {
        var stepCount = 0
        var x = range.origin.x
        var y = range.origin.y
        var exit = false
        for instruction in data.data {
            switch instruction.direction {
            case .U:
                if x == point.x && point.y >= y-instruction.distance && point.y <= y {
                    stepCount += y - point.y
                    exit = true
                    break
                }
                y -= instruction.distance
            case .D:
                if x == point.x && point.y <= abs(y+instruction.distance) && point.y >= y {
                    stepCount += point.y - y
                    exit = true
                    break
                }
                y += instruction.distance
            case .L:
                if y == point.y && point.x >= x-instruction.distance && point.x <= x {
                    stepCount += x - point.x
                    exit = true
                    break
                }
                x -= instruction.distance
            case .R:
                if y == point.y && point.x <= abs(x+instruction.distance) && point.x >= x {
                    stepCount += point.x - x
                    exit = true
                    break
                }
                x += instruction.distance
            }
            guard !exit else { break }
            stepCount += instruction.distance
        }
        return stepCount
    }
    
    public mutating func plot(_ data: WireData) {
        wireData.append(data)
        var x = range.origin.x
        var y = range.origin.y
        var points = [GridRef:Int]()

        for instruction in data.data {
            switch instruction.direction {
            case .U:
                for i in 1..<instruction.distance {
                    let point = GridRef(x: x, y: y-i)
                    points[point] = 1
                }
                y -= instruction.distance
            case .D:
                for i in 1..<instruction.distance {
                    let point = GridRef(x: x, y: y+i)
                    points[point] = 1
                }
                y += instruction.distance
            case .L:
                for i in 1..<instruction.distance {
                    let point = GridRef(x: x-i, y: y)
                    points[point] = 1
                }
                x -= instruction.distance
            case .R:
                for i in 1..<instruction.distance {
                    let point = GridRef(x: x+i, y: y)
                    points[point] = 1
                }
                x += instruction.distance
            }
        }

        self.points.merge(points) { $0 + $1 }
    }
}

extension WireData.DirectionRange: Equatable {
    
}
