import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [Tile]) -> Int {
        let sides = allSides(input)
        let cornerTiles = self.cornerTiles(input, sides: sides)
        return cornerTiles.reduce(1) { $0 * $1.id }
    }
    
    public func part2(_ input: [Tile]) -> Int {
        let size = Int(sqrt(Double(input.count)))
        let sides = allSides(input)
        var cornerTiles = self.cornerTiles(input, sides: sides)
        var edgeTiles = self.edgeTiles(input, sides: sides)
        var middleTiles = input.filter { !cornerTiles.contains($0) && !edgeTiles.contains($0) }
        assert(cornerTiles.count + edgeTiles.count + middleTiles.count == input.count)
        var topLeft = input.first(where: { $0.id == cornerTiles.first!.id })!
        while sides[topLeft.top]!.count != 1 || sides[topLeft.left]!.count != 1 {
            topLeft = topLeft.rotate
        }

        var tiles = [Point: [Tile]]()
        tiles[.zero] = [topLeft]
        
        func indexOf(_ tile: Tile, items: [Tile]) -> Int {
            for i in 0..<items.count {
                if items[i].id == tile.id {
                    return i
                }
            }
            return -1
        }
        
        cornerTiles.remove(at: indexOf(topLeft, items: cornerTiles))
        
        // fill in top row
        for x in 1..<size-1 {
            let point = Point(x: x, y: 0)
            let options = tiles[point + Position.l.point]!
            let possible = findTiles(top: nil, left: options, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible[0], items: edgeTiles))
        }
        
        // top right corner
        var point = Point(x: size-1, y: 0)
        var options = tiles[point + Position.l.point]!
        var possible = findTiles(top: nil, left: options, tiles: cornerTiles)
        tiles[point] = possible
        cornerTiles.remove(at: indexOf(possible[0], items: cornerTiles))
        
        // fill in left column
        for y in 1..<size-1 {
            let point = Point(x: 0, y: y)
            let options = tiles[point + Position.t.point]!
            let possible = findTiles(top: options, left: nil, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible[0], items: edgeTiles))
        }
        
        // bottom left corner
        point = Point(x: 0, y: size-1)
        options = tiles[point + Position.t.point]!
        possible = findTiles(top: options, left: nil, tiles: cornerTiles)
        tiles[point] = possible
        cornerTiles.remove(at: indexOf(possible[0], items: cornerTiles))
        
        // fill in right column
        for y in 1..<size-1 {
            let point = Point(x: size-1, y: y)
            let options = tiles[point + Position.t.point]!
            let possible = findTiles(top: options, left: nil, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible[0], items: edgeTiles))
        }
        
        // fill in bottom row
        for x in 1..<size-1 {
            let point = Point(x: x, y: size-1)
            let options = tiles[point + Position.l.point]!
            let possible = findTiles(top: nil, left: options, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible[0], items: edgeTiles))
        }
        
        // bottom right corner
        point = Point(x: size-1, y: size-1)
        options = tiles[point + Position.l.point]!
        possible = findTiles(top: nil, left: options, tiles: cornerTiles)
        tiles[point] = possible
        cornerTiles.remove(at: indexOf(possible[0], items: cornerTiles))
        
        // middle tiles
        for y in 1..<size-1 {
            for x in 1..<size-1 {
                let point = Point(x: x, y: y)
                let leftOptions = tiles[point + Position.l.point]!
                let topOptions = tiles[point + Position.t.point]!
                let possible = findTiles(top: topOptions, left: leftOptions, tiles: middleTiles)
                tiles[point] = possible
                middleTiles.remove(at: indexOf(possible[0], items: middleTiles))
            }
        }
        
        print("Hello")
        
        return 0
    }
}

public extension Day20 {    
    func findTiles(top: [Tile]?, left: [Tile]?, tiles: [Tile]) -> [Tile] {
        var existingTiles = Set<Int>()
        var foundTiles = [Tile]()
        var allTop = Set<String>()
        var allLeft = Set<String>()

        var visibleSides = [String]()
        if let top = top {
            for t in top {
                visibleSides.append(t.bottom)
                allTop.insert(t.bottom)
                existingTiles.insert(t.id)
            }
        }
        if let left = left {
            for t in left {
                visibleSides.append(t.right)
                allLeft.insert(t.right)
                existingTiles.insert(t.id)
            }
        }

        for tile in tiles {
            var count = 0
            for side in visibleSides {
                if tile.sides.contains(side) {
                    count += 1
                }
            }
            if count >= min(2, visibleSides.count) {
                foundTiles.append(tile)
            }
        }
        
        return foundTiles.compactMap {
            rotate($0, top: allTop, left: allLeft)
        }
    }
    
    func rotate(_ tile: Tile, top: Set<String>, left: Set<String>) -> Tile? {
        var tile = tile
        for _ in 0..<4 {
            if (top.isEmpty || top.contains(tile.top)) && (left.isEmpty || left.contains(tile.left)) {
                return tile
            }
            tile = tile.rotate
        }
        tile = tile.flip
        for _ in 0..<4 {
            if (top.isEmpty || top.contains(tile.top)) && (left.isEmpty || left.contains(tile.left)) {
                return tile
            }
            tile = tile.rotate
        }
        return nil
    }
    
    func allSides(_ input: [Tile]) -> [String: [Tile]] {
        var sides = [String: [Tile]]()
        for tile in input {
            for side in tile.sides {
                var tiles = sides[side] ?? []
                tiles.append(tile)
                sides[side] = tiles
            }
        }
        return sides
    }
    
    func cornerTiles(_ input: [Tile], sides: [String: [Tile]]) -> [Tile] {
        var cornerTiles = [Tile]()
        for tile in input {
            var count1 = 0
            var count2 = 0
            for side in [tile.top, tile.bottom, tile.left, tile.right] {
                if sides[side]!.count == 1 {
                    count1 += 1
                } else if sides[side]!.count == 2 {
                    count2 += 1
                }
            }
            if count1 == 2 && count2 == 2 {
                cornerTiles.append(tile)
            }
        }
        return cornerTiles
    }
    
    func edgeTiles(_ input: [Tile], sides: [String: [Tile]]) -> [Tile] {
        var cornerTiles = [Tile]()
        for tile in input {
            var count1 = 0
            var count2 = 0
            for side in [tile.top, tile.bottom, tile.left, tile.right] {
                if sides[side]!.count == 1 {
                    count1 += 1
                } else if sides[side]!.count == 2 {
                    count2 += 1
                }
            }
            if count1 == 1 && count2 == 3 {
                cornerTiles.append(tile)
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
    struct Tile: Hashable {
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
        
        public var sides: [String] {
            [top, bottom, left, right, flippedTop, flippedBottom, flippedLeft, flippedRight]
        }
        
        public init(id: Int, data: [String]) {
            self.id = id
            self.data = data
            
            top = data.first!
            bottom = data.last!
            var left = "", right = ""
            for line in data {
                left.append(line.first!)
                right.append(line.last!)
            }
            self.left = left
            self.right = right
        }
        
        public var flip: Tile {
            let reversedData = data.map { String($0.reversed()) }
            return Tile(id: id, data: reversedData)
        }
        
        public var rotate: Tile {
            var rotatedData = [String]()
            let size = data[0].count
            for x in 0..<size {
                var line = ""
                for y in 0..<size {
                    line.append(data[size - 1 - y][x])
                }
                rotatedData.append(line)
            }
            
            return Tile(id: id, data: rotatedData)
        }
        
        public func edge(_ direction: Direction) -> String {
            switch direction {
            case .n: return top
            case .e: return right
            case .s: return bottom
            case .w: return bottom
            }
        }
        
        public func edgeFlipped(_ direction: Direction) -> String {
            return String(edge(direction).reversed())
        }
    }
}
