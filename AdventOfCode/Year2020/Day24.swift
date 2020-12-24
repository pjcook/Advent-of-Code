import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    public func part1(_ input: [[HexDirection]]) -> Int {
        // start white
        return layFloor(input).reduce(0) { $0 + ($1.value == .black ? 1 : 0) }
    }
    
    public func part2(_ input: [[HexDirection]]) -> Int {
        // .black with 0 of > 2 .black adjacent == .white
        // .white with 2 adjacent .black == .black
        var floor = layFloor(input)
        
        for i in 0..<100 {
            floor = pad(floor)
            var newFloor = floor
            
            for tile in floor {
                let adjacentBlackTileCount = adjacent(tile.key)
                    .compactMap { floor[$0] }
                    .filter { $0 == .black }
                    .count
                
                switch tile.value {
                case .black:
                    newFloor[tile.key] = [1,2].contains(adjacentBlackTileCount) ? .black : .white
                    
                case .white:
                    newFloor[tile.key] = adjacentBlackTileCount == 2 ? .black : .white
                }
            }
            
            floor = newFloor
            print(i+1, floor.reduce(0) { $0 + ($1.value == .black ? 1 : 0) })
        }
        
        return floor.reduce(0) { $0 + ($1.value == .black ? 1 : 0) }
    }
    
    func pad(_ floor: [Pointf: Color]) -> [Pointf: Color] {
        var padded = floor
        
        for tile in floor {
            for point in adjacent(tile.key) {
                if padded[point] == nil {
                    padded[point] = .white
                }
            }
        }
        
        return padded
    }
    
    func adjacent(_ tile: Pointf) -> [Pointf] {
        return HexDirection.adjacent.map { tile + $0 }
    }
}

public extension Day24 {
    func layFloor(_ input: [[HexDirection]]) -> [Pointf: Color] {
        var floor = [Pointf: Color]()
        for instruction in input {
            var point = Pointf.zero
            for direction in instruction {
                point = point + direction.point
            }
            let color = floor[point, default: .white]
            floor[point] = color.flipped
        }
        return floor
    }
    
    func parse(_ input: [String]) -> [[HexDirection]] {
        var instructions = [[HexDirection]]()
        
        for line in input {
            var directions = [HexDirection]()
            var i = 0
            while i < line.count {
                if i < line.count-1, let direction = HexDirection(rawValue: line[i] + line[i+1]) {
                    directions.append(direction)
                    i += 2
                } else {
                    let direction = HexDirection(rawValue: line[i])!
                    directions.append(direction)
                    i += 1
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
        
        public var character: Character {
            self == .white ? "⬢" : "⬡"
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
