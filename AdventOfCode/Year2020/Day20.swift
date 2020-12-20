import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [Tile]) -> Int {
        let sides = allSides(input)
        let cornerTiles = self.cornerTiles(input, sides: sides)
        return cornerTiles.reduce(1, *)
    }
    
    public func part2(_ input: [Tile]) -> Int {
        let size = Int(sqrt(Double(input.count)))
        let sides = allSides(input)
        let cornerTiles = self.cornerTiles(input, sides: sides)
        
        
        
        var tiles = [[Tile]]()
        for y in 0..<size {
            for x in 0..<size {
                
                tiles[y][x] = tile
            }
        }
        
        
        return 0
    }
}

public extension Day20 {
    func allSides(_ input: [Tile]) -> [String: Int] {
        var sides = [String: Int]()
        for tile in input {
            for side in [tile.top, tile.bottom, tile.left, tile.right, tile.flippedTop, tile.flippedBottom, tile.flippedLeft, tile.flippedRight] {
                var count = sides[side] ?? 0
                count += 1
                sides[side] = count
            }
        }
        return sides
    }
    
    func cornerTiles(_ input: [Tile], sides: [String: Int]) -> [Int] {
        var cornerTiles = [Int]()
        for tile in input {
            var count1 = 0
            var count2 = 0
            for side in [tile.top, tile.bottom, tile.left, tile.right] {
                if sides[side] == 1 {
                    count1 += 1
                } else if sides[side] == 2 {
                    count2 += 1
                }
            }
            if count1 == 2 && count2 == 2 {
                cornerTiles.append(tile.id)
            }
        }
        return cornerTiles
    }
}

public extension Day20 {
    func parse(_ input: [String]) throws -> [Tile] {
        var tiles = [Tile]()
        var data = [String]()
        var id = 0
        let regex = try RegularExpression(pattern: #"^Tile ([\d]+):$"#)
        
        func processLine(_ line: String) throws {
            if line.hasPrefix("Tile ") {
                let match = try regex.match(line)
                id = try match.integer(at: 0)
            } else if line.isEmpty {
                tiles.append(Tile(id: id, data: data))
                data = []
                id = 0
            } else if line == "" {
                
            } else {
                data.append(line)
            }
        }
        
        for line in input {
            try processLine(line)
        }
        try processLine("")
        
        return tiles
    }
}

public extension Day20 {
    struct Tile {
        public let id: Int
        public let data: [String]
        
        public let top: String
        public let bottom: String
        public let left: String
        public let right: String
        
        public var flippedTop: String { String(top.reversed()) }
        public var flippedBottom: String { String(bottom.reversed()) }
        public var flippedLeft: String { String(left.reversed()) }
        public var flippedRight: String { String(right.reversed()) }
        
        public init(id: Int, data: [String]) {
            self.id = id
            self.data = data
            
            top = data.first!
            bottom = String(data.last!.reversed())
            var left = "", right = ""
            for line in data {
                left.append(line.first!)
                right.append(line.last!)
            }
            self.left = String(left.reversed())
            self.right = right
        }
    }
}
