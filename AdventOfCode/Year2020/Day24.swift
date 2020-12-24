import Foundation
import StandardLibraries

public struct Day24 {
    public typealias Floor = [Pointf: Color]
    public typealias Instructions = [[HexDirection]]
    
    public init() {}
    
    public func part1(_ input: Instructions) -> Int {
        // start white
        return layFloor(input).count
    }
    
    public func part2(_ input: Instructions) -> Int {
        // .black with 0 of > 2 .black adjacent == .white
        // .white with 2 adjacent .black == .black
        var floor = layFloor(input)
        
        for _ in 0..<100 {
            let blackTiles = Set(floor.keys)
            let points = Set(blackTiles.reduce([], { $0 + adjacent($1) }) + blackTiles)
            var newFloor = floor
            
            for point in points {
                let adjacentBlackTileCount = adjacent(point)
                    .filter { blackTiles.contains($0) }
                    .count
                if blackTiles.contains(point) {
                    if adjacentBlackTileCount == 0 || adjacentBlackTileCount > 2 {
                        newFloor.removeValue(forKey: point)
                    }
                } else if adjacentBlackTileCount == 2 {
                    newFloor[point] = .black
                }
            }
            
            floor = newFloor
        }
        
        return floor.count
    }
    
    func adjacent(_ tile: Pointf) -> [Pointf] {
        return HexDirection.adjacent.map { tile + $0 }
    }
}

public extension Day24 {
    func layFloor(_ input: Instructions) -> Floor {
        var floor = Floor()
        for instruction in input {
            var point = Pointf.zero
            for direction in instruction {
                point = point + direction.point
            }
            if floor[point, default: .white] == .white {
                floor[point] = .black
            } else {
                floor.removeValue(forKey: point)
            }
        }
        return floor
    }
    
    func parse(_ input: [String]) -> Instructions {
        var instructions = Instructions()
        
        for var line in input {
            var directions = [HexDirection]()
            
            while !line.isEmpty {
                switch line.removeFirst() {
                case "e": directions.append(.east)
                case "w": directions.append(.west)
                case "n":
                    switch line.removeFirst() {
                    case "e": directions.append(.northeast)
                    case "w": directions.append(.northwest)
                    default: break
                    }
                case "s":
                    switch line.removeFirst() {
                    case "e": directions.append(.southeast)
                    case "w": directions.append(.southwest)
                    default: break
                    }
                default: break
                }
            }
            
            instructions.append(directions)
        }
        
        return instructions
    }
}

public extension Day24 {
    enum Color {
        case white, black
        
        public var flipped: Color {
            self == .white ? .black : .white
        }
    }
    
    enum HexDirection: String {
        case east = "e"
        case southeast = "se"
        case southwest = "sw"
        case west = "w"
        case northwest = "nw"
        case northeast = "ne"
        
        public var point: Pointf {
            switch self {
            case .east: return Pointf(x: 2, y: 0)
            case .southeast: return Pointf(x: 1.0, y: -1.5)
            case .southwest: return Pointf(x: -1.0, y: -1.5)
            case .west: return Pointf(x: -2, y: 0)
            case .northwest: return Pointf(x: -1.0, y: 1.5)
            case .northeast: return Pointf(x: 1.0, y: 1.5)
            }
        }
        
        public static let adjacent: [Pointf] = [
            HexDirection.east.point,
            HexDirection.southeast.point,
            HexDirection.southwest.point,
            HexDirection.west.point,
            HexDirection.northwest.point,
            HexDirection.northeast.point,
        ]
    }
}
