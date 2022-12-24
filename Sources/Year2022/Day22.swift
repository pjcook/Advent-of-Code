//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public protocol Day22Mapping {
    var id: Day22.Side { get }
    var points: Set<Point> { get }
    var topLeft: Point { get }
    var bottomRight: Point { get }
    
    func mapping(exitPoint: Point, direction: Day22.Direction) -> (Point, Day22.Direction)
}


public struct Day22 {
    let air = " "
    let walk = "."
    let rock = "#"
    
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let (grid, instructions) = parse(input)
        var pos = Point(findStartOfRow(y: 0, grid: grid), 0)
        var direction = Direction.right
        
        for instruction in instructions {
            execute(instruction: instruction, grid: grid, pos: &pos, direction: &direction)
        }
        
        return finalAnswer(row: pos.y, col: pos.x, direction: direction)
    }
    
    public enum Side: String {
        case a, b, c, d, e, f
    }
    
    public func mapCube(grid: Grid<String>, lengthOfSide: Int) -> [Day22Mapping] {
        var sides = [Day22Mapping]()
        var remaining: [Side] = [.f, .e, .d, .c, .b, .a]
        var x = 0, y = 0
        let bottomLeft = Point(lengthOfSide-1, lengthOfSide-1) // -1 because of the zero index
        var point = Point(x, y)
        func nextPoint() {
            if x < grid.columns - lengthOfSide {
                x += lengthOfSide
            } else {
                x = 0
                y += lengthOfSide
            }
            point = Point(x, y)
        }

        while let sideId = remaining.popLast() {
            while grid[point] == air {
                nextPoint()
            }
            
            sides.append(AutoMapping(id: sideId, minMax: (point, point + bottomLeft)))
            nextPoint()
        }
        
        var finalSides = [Day22Mapping]()
        
        /*  U D L R
         1
         2
         3
         4
         5
         6
         
         1 === side.a
         */
        let mid = Point(lengthOfSide / 2, lengthOfSide / 2)
        
        func neighbour(compassDirection: CompassDirection, point: Point) -> Day22Mapping? {
            let point = point.add(direction: compassDirection, distance: lengthOfSide)
            return sides.first(where: { $0.points.contains(point) })
        }
        
        var mapGrid = Grid(columns: 4, items: Array(repeating: 0, count: 4*6))
        let one = sides.first(where: { $0.id == .a })!
        var lookup = [Int: Point]()
        lookup[1] = one.topLeft + mid
        let initialSearch = [
            1:(4,3,5,2),
            2:(4,3,1,6),
            3:(1,6,5,2),
            4:(5,2,1,6),
            5:(3,4,1,6),
            6:(3,4,5,2)
        ]
        
        var queue = [1,2,3,4,5,6]
        while !queue.isEmpty {
            let next = queue.removeFirst()
            guard let point = lookup[next] else {
                queue.append(next)
                continue
            }
            let details = initialSearch[next]!
            
            if let neg = neighbour(compassDirection: .e, point: point) {
                let point = neg.topLeft + mid
                if let key = lookup.first(where: { $0.value == point })?.key {
                    if mapGrid[Point(3, next-1)] == 0 {
                        mapGrid[Point(3, next-1)] = key
                        mapGrid[Point(2, next-1)] = 7 - key
                    }
                } else {
                    if lookup[details.3] == nil {
                        lookup[details.3] = point
                    } else if mapGrid[Point(3, next-1)] != 0 {
                        lookup[mapGrid[Point(3, next-1)]] = point
                    }  else {
                        queue.append(next)
                    }
                    if mapGrid[Point(3, next-1)] == 0 {
                        mapGrid[Point(3, next-1)] = details.3
                        mapGrid[Point(2, next-1)] = details.2
                    }
                }
                
                // neighbours above and below would also share the same side
                if let neg = neighbour(compassDirection: .s, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {  // above (reverse vertical compass points because numbers increase down
                    mapGrid[Point(3, key-1)] = mapGrid[Point(3, next-1)]
                    mapGrid[Point(2, key-1)] = mapGrid[Point(2, next-1)]
                }
                if let neg = neighbour(compassDirection: .n, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {
                    mapGrid[Point(3, key-1)] = mapGrid[Point(3, next-1)]
                    mapGrid[Point(2, key-1)] = mapGrid[Point(2, next-1)]
                }
            }
            
            if let neg = neighbour(compassDirection: .w, point: point) {
                let point = neg.topLeft + mid
                if let key = lookup.first(where: { $0.value == point })?.key {
                    if mapGrid[Point(3, next-1)] == 0 {
                        mapGrid[Point(3, next-1)] = 7 - key
                        mapGrid[Point(2, next-1)] = key
                    }
                } else {
                    if lookup[details.2] == nil {
                        lookup[details.2] = point
                    } else if mapGrid[Point(2, next-1)] != 0 {
                        lookup[mapGrid[Point(2, next-1)]] = point
                    } else {
                        queue.append(next)
                    }
                    if mapGrid[Point(3, next-1)] == 0 {
                        mapGrid[Point(3, next-1)] = details.3
                        mapGrid[Point(2, next-1)] = details.2
                    }
                }
                
                // neighbours above and below would also share the same side
                if let neg = neighbour(compassDirection: .s, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {  // above (reverse vertical compass points because numbers increase down
                    mapGrid[Point(3, key-1)] = mapGrid[Point(3, next-1)]
                    mapGrid[Point(2, key-1)] = mapGrid[Point(2, next-1)]
                }
                if let neg = neighbour(compassDirection: .n, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {
                    mapGrid[Point(3, key-1)] = mapGrid[Point(3, next-1)]
                    mapGrid[Point(2, key-1)] = mapGrid[Point(2, next-1)]
                }
            }
            
            if let neg = neighbour(compassDirection: .n, point: point) {
                let point = neg.topLeft + mid
                if let key = lookup.first(where: { $0.value == point })?.key {
                    if mapGrid[Point(1, next-1)] == 0 {
                        mapGrid[Point(1, next-1)] = key
                        mapGrid[Point(0, next-1)] = 7 - key
                    }
                } else {
                    if lookup[details.1] == nil {
                        lookup[details.1] = point
                    } else if mapGrid[Point(1, next-1)] != 0 {
                        lookup[mapGrid[Point(1, next-1)]] = point
                    }  else {
                        queue.append(next)
                    }
                    if mapGrid[Point(1, next-1)] == 0 {
                        mapGrid[Point(1, next-1)] = details.1
                        mapGrid[Point(0, next-1)] = details.0
                    }
                }
                
                // neighbours above and below would also share the same side
                if let neg = neighbour(compassDirection: .e, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {  // above (reverse vertical compass points because numbers increase down
                    mapGrid[Point(1, key-1)] = mapGrid[Point(1, next-1)]
                    mapGrid[Point(0, key-1)] = mapGrid[Point(0, next-1)]
                }
                if let neg = neighbour(compassDirection: .w, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {
                    mapGrid[Point(1, key-1)] = mapGrid[Point(1, next-1)]
                    mapGrid[Point(0, key-1)] = mapGrid[Point(0, next-1)]
                }
            }
            
            if let neg = neighbour(compassDirection: .s, point: point) {
                let point = neg.topLeft + mid
                if let key = lookup.first(where: { $0.value == point })?.key {
                    if mapGrid[Point(1, next-1)] == 0 {
                        mapGrid[Point(1, next-1)] = 7 - key
                        mapGrid[Point(0, next-1)] = key
                    }
                } else {
                    if lookup[details.0] == nil {
                        lookup[details.0] = point
                    } else if mapGrid[Point(0, next-1)] != 0 {
                        lookup[mapGrid[Point(0, next-1)]] = point
                    }  else {
                        queue.append(next)
                    }
                    if mapGrid[Point(1, next-1)] == 0 {
                        mapGrid[Point(1, next-1)] = details.1
                        mapGrid[Point(0, next-1)] = details.0
                    }
                }
                
                // neighbours above and below would also share the same side
                if let neg = neighbour(compassDirection: .e, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {  // above (reverse vertical compass points because numbers increase down
                    mapGrid[Point(1, key-1)] = mapGrid[Point(1, next-1)]
                    mapGrid[Point(0, key-1)] = mapGrid[Point(0, next-1)]
                }
                if let neg = neighbour(compassDirection: .w, point: point), let key = lookup.first(where: { $0.value == neg.topLeft + mid })?.key {
                    mapGrid[Point(1, key-1)] = mapGrid[Point(1, next-1)]
                    mapGrid[Point(0, key-1)] = mapGrid[Point(0, next-1)]
                }
            }
        }

        var toResolve = (0..<mapGrid.columns).compactMap({
            if mapGrid[0,$0] == 0 || mapGrid[1,$0] == 0 || mapGrid[2,$0] == 0 || mapGrid[3,$0] == 0 {
                return $0
            }
            return nil
        })
        
        while !toResolve.isEmpty {
            let next = toResolve.removeFirst()
            
            if mapGrid[0,next] == 0 && mapGrid[1,next] == 0 && mapGrid[2,next] == 0 && mapGrid[3,next] == 0 {
                toResolve.append(next)
                continue
            }
            
            if (mapGrid[0,next] == 0 || mapGrid[1,next] == 0) && (mapGrid[2,next] != 0 || mapGrid[3,next] != 0) {
                if mapGrid[2,next] != 0 {
                    mapGrid[0,next] = mapGrid[0,mapGrid[2,next]-1]
                    mapGrid[1,next] = mapGrid[1,mapGrid[2,next]-1]
                } else {
                    mapGrid[0,next] = mapGrid[0,mapGrid[3,next]-1]
                    mapGrid[1,next] = mapGrid[1,mapGrid[3,next]-1]
                }
            }
            
            if (mapGrid[2,next] == 0 || mapGrid[3,next] == 0) && (mapGrid[0,next] != 0 || mapGrid[1,next] != 0) {
                if mapGrid[0,next] != 0 {
                    mapGrid[2,next] = mapGrid[2,mapGrid[0,next]-1]
                    mapGrid[3,next] = mapGrid[3,mapGrid[0,next]-1]
                } else {
                    mapGrid[2,next] = mapGrid[2,mapGrid[1,next]-1]
                    mapGrid[3,next] = mapGrid[3,mapGrid[1,next]-1]
                }
            }
            
            if mapGrid[0,next] == 0 || mapGrid[1,next] == 0 || mapGrid[2,next] == 0 || mapGrid[3,next] == 0 {
                toResolve.append(next)
            }
        }

        mapGrid.draw()
        return finalSides
    }
    
    public struct AutoMapping: Day22Mapping, Hashable, CustomStringConvertible {
        public static func == (lhs: Day22.AutoMapping, rhs: Day22.AutoMapping) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(points)
            hasher.combine(topLeft)
            hasher.combine(bottomRight)
        }
        
        public let id: Side
        public let points: Set<Point>
        public let topLeft: Point
        public let bottomRight: Point
        public let edges: [Direction: (Side, Int)]
        
        public init(id: Side, minMax: (Point, Point), edges: [Direction: (Side, Int)] = [:]) {
            self.id = id
            self.topLeft = minMax.0
            self.bottomRight = minMax.1
            self.points = Point.pointsIn(minMax.0, minMax.1)
            self.edges = edges
        }
        
        public init(id: Side, topLeft: Point, bottomRight: Point, points: Set<Point>, edges: [Direction: (Side, Int)]) {
            self.id = id
            self.topLeft = topLeft
            self.bottomRight = bottomRight
            self.points = points
            self.edges = edges
        }
        
        public func mapping(exitPoint: Point, direction: Direction) -> (Point, Direction) {
            return (exitPoint, direction)
        }
        
        public var description: String {
            "\(id.rawValue):\(topLeft.x):\(topLeft.y);\(bottomRight.x):\(bottomRight.y)"
        }
    }
    
    public struct ExampleMapping: Day22Mapping, Hashable {
        public static let a = ExampleMapping(id: .a, minMax: (Point(8, 0), Point(11, 3)))
        public static let b = ExampleMapping(id: .b, minMax: (Point(0, 4), Point(3, 7)))
        public static let c = ExampleMapping(id: .c, minMax: (Point(4, 4), Point(7, 7)))
        public static let d = ExampleMapping(id: .d, minMax: (Point(8, 4), Point(11, 7)))
        public static let e = ExampleMapping(id: .e, minMax: (Point(8, 8), Point(11, 11)))
        public static let f = ExampleMapping(id: .f, minMax: (Point(12, 8), Point(15, 11)))
        public static var all: [Day22Mapping] { [a, b, c, d, e, f] }

        public let id: Side
        public let points: Set<Point>
        public let topLeft: Point
        public let bottomRight: Point
        
        public init(id: Side, minMax: (Point, Point)) {
            self.id = id
            self.topLeft = minMax.0
            self.bottomRight = minMax.1
            self.points = Point.pointsIn(minMax.0, minMax.1)
        }
        
        public func mapping(exitPoint: Point, direction: Direction) -> (Point, Direction) {
            var entryPoint = exitPoint
            var newDirection = direction
            switch id {
            case .a:
                let dp = entryPoint - ExampleMapping.a.topLeft
                switch direction {
                case .right:
                    newDirection = .left
                    entryPoint = Point(ExampleMapping.f.bottomRight.x, ExampleMapping.f.bottomRight.y - dp.y)
                case .down:
                    entryPoint = Point(ExampleMapping.d.topLeft.x + dp.x, ExampleMapping.d.topLeft.y)
                case .left:
                    newDirection = .down
                    entryPoint = Point(ExampleMapping.c.topLeft.x + dp.y, ExampleMapping.c.topLeft.y)
                case .up:
                    newDirection = .down
                    entryPoint = Point(ExampleMapping.b.bottomRight.x - dp.x, ExampleMapping.b.topLeft.y)
                }
                
            case .b:
                let dp = entryPoint - ExampleMapping.b.topLeft
                switch direction {
                case .right:
                    entryPoint = Point(ExampleMapping.c.topLeft.x, ExampleMapping.c.topLeft.y + dp.y)
                case .down:
                    newDirection = .up
                    entryPoint = Point(ExampleMapping.e.bottomRight.x - dp.x, ExampleMapping.e.bottomRight.y)
                case .left:
                    newDirection = .up
                    entryPoint = Point(ExampleMapping.f.bottomRight.x - dp.y, ExampleMapping.f.bottomRight.y)
                case .up:
                    newDirection = .down
                    entryPoint = Point(ExampleMapping.a.bottomRight.x - dp.x, ExampleMapping.a.topLeft.y)
                }
                
            case .c:
                let dp = entryPoint - ExampleMapping.c.topLeft
                switch direction {
                case .right:
                    entryPoint = Point(ExampleMapping.d.topLeft.x, ExampleMapping.d.topLeft.y + dp.y)
                case .down:
                    newDirection = .right
                    entryPoint = Point(ExampleMapping.e.topLeft.x, ExampleMapping.e.bottomRight.y - dp.x)
                case .left:
                    entryPoint = Point(ExampleMapping.b.bottomRight.x, ExampleMapping.b.topLeft.y + dp.y)
                case .up:
                    newDirection = .right
                    entryPoint = Point(ExampleMapping.a.topLeft.x, ExampleMapping.a.topLeft.y + dp.x)
                }
                
            case .d:
                let dp = entryPoint - ExampleMapping.d.topLeft
                switch direction {
                case .right:
                    newDirection = .down
                    entryPoint = Point(ExampleMapping.f.bottomRight.x - dp.y, ExampleMapping.f.topLeft.y)
                case .down:
                    entryPoint = Point(ExampleMapping.e.topLeft.x + dp.x, ExampleMapping.e.topLeft.y)
                case .left:
                    entryPoint = Point(ExampleMapping.c.bottomRight.x, ExampleMapping.c.topLeft.y + dp.y)
                case .up:
                    entryPoint = Point(ExampleMapping.a.topLeft.x + dp.x, ExampleMapping.a.bottomRight.y)
                }
                
            case .e:
                let dp = entryPoint - ExampleMapping.e.topLeft
                switch direction {
                case .right:
                    entryPoint = Point(ExampleMapping.f.topLeft.x, ExampleMapping.f.topLeft.y + dp.y)
                case .down:
                    newDirection = .up
                    entryPoint = Point(ExampleMapping.b.bottomRight.x - dp.x, ExampleMapping.b.bottomRight.y)
                case .left:
                    newDirection = .up
                    entryPoint = Point(ExampleMapping.c.bottomRight.x - dp.y, ExampleMapping.c.bottomRight.y)
                case .up:
                    entryPoint = Point(ExampleMapping.d.topLeft.x + dp.x, ExampleMapping.d.bottomRight.y)
                }
                
            case .f:
                let dp = entryPoint - ExampleMapping.f.topLeft
                switch direction {
                case .right:
                    newDirection = .left
                    entryPoint = Point(ExampleMapping.a.bottomRight.x, ExampleMapping.a.bottomRight.y - dp.y)
                case .down:
                    newDirection = .right
                    entryPoint = Point(ExampleMapping.b.topLeft.x, ExampleMapping.b.bottomRight.y - dp.x)
                case .left:
                    entryPoint = Point(ExampleMapping.e.bottomRight.x, ExampleMapping.e.topLeft.y + dp.y)
                case .up:
                    entryPoint = Point(ExampleMapping.d.bottomRight.x, ExampleMapping.d.bottomRight.y - dp.x)
                }
            }
            
            return (entryPoint, newDirection)
        }
    }
    
    public struct PuzzleMapping: Day22Mapping, Hashable {
        public static let a = PuzzleMapping(id: .a, minMax: (Point(50, 0), Point(99, 49)))
        public static let b = PuzzleMapping(id: .b, minMax: (Point(100, 0), Point(149, 49)))
        public static let c = PuzzleMapping(id: .c, minMax: (Point(50, 50), Point(99, 99)))
        public static let d = PuzzleMapping(id: .d, minMax: (Point(50, 100), Point(99, 149)))
        public static let e = PuzzleMapping(id: .e, minMax: (Point(0, 100), Point(49, 149)))
        public static let f = PuzzleMapping(id: .f, minMax: (Point(0, 150), Point(49, 199)))
        public static var all: [Day22Mapping] { [a, b, c, d, e, f] }

        public let id: Side
        public let points: Set<Point>
        public let topLeft: Point
        public let bottomRight: Point
        
        public init(id: Side, minMax: (Point, Point)) {
            self.id = id
            self.topLeft = minMax.0
            self.bottomRight = minMax.1
            self.points = Point.pointsIn(minMax.0, minMax.1)
        }
        
        public func mapping(exitPoint: Point, direction: Direction) -> (Point, Direction) {
            var entryPoint = exitPoint
            var newDirection = direction
            switch id {
            case .a:
                let dp = entryPoint - PuzzleMapping.a.topLeft
                switch direction {
                case .right:
                    entryPoint = Point(PuzzleMapping.b.topLeft.x, PuzzleMapping.b.topLeft.y + dp.y)
                case .down:
                    entryPoint = Point(PuzzleMapping.c.topLeft.x + dp.x, PuzzleMapping.c.topLeft.y)
                case .left:
                    newDirection = .right
                    entryPoint = Point(PuzzleMapping.e.topLeft.x, PuzzleMapping.e.bottomRight.y - dp.y)
                case .up:
                    newDirection = .right
                    entryPoint = Point(PuzzleMapping.f.topLeft.x, PuzzleMapping.f.topLeft.y + dp.x)
                }
                
            case .b:
                let dp = entryPoint - PuzzleMapping.b.topLeft
                switch direction {
                case .right:
                    newDirection = .left
                    entryPoint = Point(PuzzleMapping.d.bottomRight.x, PuzzleMapping.d.bottomRight.y - dp.y)
                case .down:
                    newDirection = .left
                    entryPoint = Point(PuzzleMapping.c.bottomRight.x, PuzzleMapping.c.topLeft.y + dp.x)
                case .left:
                    entryPoint = Point(PuzzleMapping.a.bottomRight.x, PuzzleMapping.a.topLeft.y + dp.y)
                case .up:
                    entryPoint = Point(PuzzleMapping.f.topLeft.x + dp.x, PuzzleMapping.f.bottomRight.y)
                }
                
            case .c:
                let dp = entryPoint - PuzzleMapping.c.topLeft
                switch direction {
                case .right:
                    newDirection = .up
                    entryPoint = Point(PuzzleMapping.b.topLeft.x + dp.y, PuzzleMapping.b.bottomRight.y)
                case .down:
                    entryPoint = Point(PuzzleMapping.d.topLeft.x + dp.x, PuzzleMapping.d.topLeft.y)
                case .left:
                    newDirection = .down
                    entryPoint = Point(PuzzleMapping.e.topLeft.x + dp.y, PuzzleMapping.e.topLeft.y)
                case .up:
                    entryPoint = Point(PuzzleMapping.a.topLeft.x + dp.x, PuzzleMapping.a.bottomRight.y)
                }
                
            case .d:
                let dp = entryPoint - PuzzleMapping.d.topLeft
                switch direction {
                case .right:
                    newDirection = .left
                    entryPoint = Point(PuzzleMapping.b.bottomRight.x, PuzzleMapping.b.bottomRight.y - dp.y)
                case .down:
                    newDirection = .left
                    entryPoint = Point(PuzzleMapping.f.bottomRight.x, PuzzleMapping.f.topLeft.y + dp.x)
                case .left:
                    entryPoint = Point(PuzzleMapping.e.bottomRight.x, PuzzleMapping.e.topLeft.y + dp.y)
                case .up:
                    entryPoint = Point(PuzzleMapping.c.topLeft.x + dp.x, PuzzleMapping.c.bottomRight.y)
                }
                
            case .e:
                let dp = entryPoint - PuzzleMapping.e.topLeft
                switch direction {
                case .right:
                    entryPoint = Point(PuzzleMapping.d.topLeft.x, PuzzleMapping.d.topLeft.y + dp.y)
                case .down:
                    entryPoint = Point(PuzzleMapping.f.topLeft.x + dp.x, PuzzleMapping.f.topLeft.y)
                case .left:
                    newDirection = .right
                    entryPoint = Point(PuzzleMapping.a.topLeft.x, PuzzleMapping.a.bottomRight.y - dp.y)
                case .up:
                    newDirection = .right
                    entryPoint = Point(PuzzleMapping.c.topLeft.x, PuzzleMapping.c.topLeft.y + dp.x)
                }
                
            case .f:
                let dp = entryPoint - PuzzleMapping.f.topLeft
                switch direction {
                case .right:
                    newDirection = .up
                    entryPoint = Point(PuzzleMapping.d.topLeft.x + dp.y, PuzzleMapping.d.bottomRight.y)
                case .down:
                    entryPoint = Point(PuzzleMapping.b.topLeft.x + dp.x, PuzzleMapping.b.topLeft.y)
                case .left:
                    newDirection = .down
                    entryPoint = Point(PuzzleMapping.a.topLeft.x + dp.y, PuzzleMapping.a.topLeft.y)
                case .up:
                    entryPoint = Point(PuzzleMapping.e.topLeft.x + dp.x, PuzzleMapping.e.bottomRight.y)
                }
            }
            
            return (entryPoint, newDirection)
        }
    }
    
    public func part2(_ input: [String], mappings: [Day22Mapping]) -> Int {
        let (grid, instructions) = parse(input)
        var pos = Point(findStartOfRow(y: 0, grid: grid), 0)
        var direction = Direction.right
        
        for instruction in instructions {
            executeCube(instruction: instruction, grid: grid, pos: &pos, direction: &direction, mappings: mappings)
        }
        
        return finalAnswer(row: pos.y, col: pos.x, direction: direction)
    }
}

extension Day22 {
    public func execute(instruction: Instruction, grid: Grid<String>, pos: inout Point, direction: inout Direction) {
        switch instruction {
        case let .move(value):
//            print("Move:\(value)")
        moveloop: for _ in (0..<value) {
                var nextPos = pos + direction.move()
            
                // Stay on the grid
                switch direction {
                case .right:
                    if nextPos.x >= grid.columns {
                        nextPos = Point(findStartOfRow(y: nextPos.y, grid: grid), nextPos.y)
                    }
                case .down:
                    if nextPos.y >= grid.rows {
                        nextPos = Point(nextPos.x, findStartOfColumn(x: nextPos.x, grid: grid))
                    }
                case .left:
                    if nextPos.x < 0 {
                        nextPos = Point(findEndOfRow(y: nextPos.y, grid: grid), nextPos.y)
                    }
                case .up:
                    if nextPos.y < 0 {
                        nextPos = Point(nextPos.x, findEndOfColumn(x: nextPos.x, grid: grid))
                    }
                }
            
                // Can you move to next position
                switch grid[nextPos] {
                case air:
                    switch direction {
                    case .right:
                        nextPos = Point(findStartOfRow(y: nextPos.y, grid: grid), nextPos.y)
                    case .down:
                        nextPos = Point(nextPos.x, findStartOfColumn(x: nextPos.x, grid: grid))
                    case .left:
                        nextPos = Point(findEndOfRow(y: nextPos.y, grid: grid), nextPos.y)
                    case .up:
                        nextPos = Point(nextPos.x, findEndOfColumn(x: nextPos.x, grid: grid))
                    }
                    
                    switch grid[nextPos] {
                    case walk:
                        pos = nextPos
                    case rock:
                        break moveloop
                    default:
                        break
                    }
                    
                case walk:
                    pos = nextPos
                case rock:
                    break moveloop
                default:
                    break
                }
            }
            
        case .turnRight:
//            print("Turn right")
            direction = direction.turnRight()
        case .turnLeft:
//            print("Turn left")
            direction = direction.turnLeft()
        }
    }
    
    public func executeCube(instruction: Instruction, grid: Grid<String>, pos: inout Point, direction: inout Direction, mappings: [Day22Mapping]) {
        var cube = mappings.first(where: { $0.points.contains(pos) })!
        switch instruction {
        case let .move(value):
//            print("Move:\(value)")
        moveloop: for _ in (0..<value) {
                var nextPos = pos + direction.move()
                var nextDirection = direction
            
                // Stay on the grid
                if !cube.points.contains(nextPos) {
                    (nextPos, nextDirection) = cube.mapping(exitPoint: pos, direction: direction)
                }
            
                // Can you move to next position
                switch grid[nextPos] {
                case air:
                    (nextPos, nextDirection) = cube.mapping(exitPoint: pos, direction: direction)
                    
                    switch grid[nextPos] {
                    case walk:
                        pos = nextPos
                        direction = nextDirection
                        cube = mappings.first(where: { $0.points.contains(pos) })!
                    case rock:
                        break moveloop
                    default:
                        break
                    }
                    
                case walk:
                    pos = nextPos
                    direction = nextDirection
                    cube = mappings.first(where: { $0.points.contains(pos) })!
                case rock:
                    break moveloop
                default:
                    break
                }
            }
            
        case .turnRight:
//            print("Turn right")
            direction = direction.turnRight()

        case .turnLeft:
//            print("Turn left")
            direction = direction.turnLeft()

        }
    }
    
    public func findStartOfRow(y: Int, grid: Grid<String>) -> Int {
        for x in (0..<grid.columns) {
            guard grid[x,y] == air else { return x }
        }
        return 0
    }
    
    public func findStartOfColumn(x: Int, grid: Grid<String>) -> Int {
        for y in (0..<grid.rows) {
            guard grid[x,y] == air else { return y }
        }
        return 0
    }
    
    public func findEndOfRow(y: Int, grid: Grid<String>) -> Int {
        for x in (0..<grid.columns).reversed() {
            guard grid[x,y] == air else { return x }
        }
        return 0
    }
    
    public func findEndOfColumn(x: Int, grid: Grid<String>) -> Int {
        for y in (0..<grid.rows).reversed() {
            guard grid[x,y] == air else { return y }
        }
        return 0
    }
    
    public func finalAnswer(row: Int, col: Int, direction: Direction) -> Int {
        let rowMultiplier = 1000
        let colMultiplier = 4
        
        return (row + 1) * rowMultiplier + (col + 1) * colMultiplier + direction.rawValue
    }
    
    public enum Direction: Int, Hashable {
        case right = 0
        case down = 1
        case left = 2
        case up = 3
        
        static let all: [Direction] = [.right, .down, .left, .up]
        
        func move() -> Point {
            switch self {
            case .right: return Point(1, 0)
            case .down: return Point(0, 1)
            case .left: return Point(-1, 0)
            case .up: return Point(0, -1)
            }
        }
        
        func turnLeft() -> Direction {
            switch self {
            case .right: return .up
            case .down: return .right
            case .left: return .down
            case .up: return .left
            }
        }
        
        func turnRight() -> Direction {
            switch self {
            case .right: return .down
            case .down: return .left
            case .left: return .up
            case .up: return .right
            }
        }
        
        func toString() -> String {
            switch self {
            case .right: return ">"
            case .down: return "v"
            case .left: return "<"
            case .up: return "^"
            }
        }
    }
    
    public enum Instruction {
        case move(Int)
        case turnRight
        case turnLeft
    }
    
    public typealias Instructions = [Instruction]
    
    public func parse(_ input: [String]) -> (Grid<String>, Instructions) {
        let groups = input.split(separator: "")
        let columns = groups[0].map({ $0.count }).max()!
        let rows = groups[0].count
        var grid = Grid(columns: columns, items: Array(repeating: air, count: columns * rows))
        
        for y in (0..<rows) {
            let line = groups[0][y]
            for x in (0..<columns) {
                let point = Point(x, y)
                guard x < line.count else {
                    grid[point] = air
                    continue
                }
                
                grid[point] = String(line[x])
            }
        }
        
        var instructions = Instructions()
        var previous = ""
        let path = groups[1].first!
        for i in (0..<path.count) {
            let c = String(path[i])
            if ["R","L"].contains(c) {
                instructions.append(.move(Int(previous)!))
                previous = ""
                instructions.append(c == "R" ? .turnRight : .turnLeft)
            } else {
                previous.append(c)
            }
            if i == path.count - 1, !previous.isEmpty {
                instructions.append(.move(Int(previous)!))
            }
        }
        
        return (grid, instructions)
    }
}
