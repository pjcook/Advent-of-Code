import Foundation
import StandardLibraries

public struct Day18 {
    public typealias Map = [Point: Tile]
    
    public init() {}
    
    public func part1(_ input: [String], size: Int = 50) -> Int {
        var map = parse(input)
        
        for _ in (0..<10) {
            map = update(map, size)
//            draw(map, size: size)
        }
        
        return map.filter({ $0.value == .trees }).count * map.filter({ $0.value == .lumberyard }).count
    }
    
    public func part2(_ input: [String], size: Int = 50) -> Int {
        var map = parse(input)
        
        for _ in (0..<1000) {
            map = update(map, size)
        }
        
        return map.filter({ $0.value == .trees }).count * map.filter({ $0.value == .lumberyard }).count
    }
}

extension Day18 {
    public func draw(_ map: Map, size: Int) {
        for y in (0..<size) {
            var line = ""
            for x in (0..<size) {
                let point = Point(x,y)
                line.append(map[point]!.rawValue)
            }
            print(line)
        }
        print()
    }
}

extension Day18 {
    public func update(_ map: Map, _ size: Int) -> Map {
        var output = map
        
        for y in (0..<size) {
            for x in (0..<size) {
                let point = Point(x,y)
                let tile = map[point]
                
                let adjacent = Tile.adjacent.map { map[point + $0] }
                
                switch tile {
                case .ground:
                    if adjacent.filter({ $0 == .trees }).count >= 3 {
                        output[point] = .trees
                    }
                    
                case .lumberyard:
                    if adjacent.first(where: { $0 == .lumberyard }) != nil && adjacent.first(where: { $0 == .trees }) != nil {
                        // do nothing
                    } else {
                        output[point] = .ground
                    }
                    
                case .trees:
                    if adjacent.filter({ $0 == .lumberyard }).count >= 3 {
                        output[point] = .lumberyard
                    }
                    
                default:
                    break
                }
            }
        }
        
        return output
    }
}

extension Day18 {
    public func parse(_ input: [String]) -> Map {
        var map = Map()
        
        for y in (0..<input.count) {
            let line = input[y]
            for x in (0..<line.count) {
                let point = Point(x,y)
                map[point] = Tile(rawValue: Character(String(line[x])))!
            }
        }
        
        return map
    }
    
    public enum Tile: Character {
        case ground = "."
        case trees = "|"
        case lumberyard = "#"
                
        public static var adjacent = [
            Point(-1,-1),
            Point(0,-1),
            Point(1,-1),
            Point(-1,0),
            Point(1,0),
            Point(-1,1),
            Point(0,1),
            Point(1,1)
        ]
    }
}
