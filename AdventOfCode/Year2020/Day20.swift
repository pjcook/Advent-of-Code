import Foundation
import InputReader
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [Tile]) -> Int {
        let sides = allSides(input)
        let (cornerTiles, _) = self.cornerAndEdgeTiles(input, sides: sides)
        return cornerTiles.reduce(1) { $0 * $1.id }
    }
    
    public func part2(_ input: [Tile]) -> Int {
        let size = Int(sqrt(Double(input.count)))
        let tiles = solveJigsaw(size, input: input)
        
//        draw(constructBigGrid(tiles, size: size))
                
        // Construct main grid
        var grid = constructGrid(tiles, size: size)
        
        // Orient the grid
        let matches = orientAndScanForMonsters(&grid)

        // Search for sea monsters
        return grid.reduce(0) { $0 + ($1.reduce(0) { $0 + ($1 == "#" ? 1 : 0) }) } - (matches * 15)
    }
}

public extension Day20 {
    /*
                       #
     #    ##    ##    ###
      #  #  #  #  #  #
     */
    struct SeaMonster {
        public init() {}
        public let regex = try! RegularExpression(pattern: "(#....##....##....###)+")
                
        public func allPoints(from tail: Point) -> [Point] {
            return [
                tail + Point(x: 18, y: -1),
                tail + Point(x: 1, y: 1),
                tail + Point(x: 4, y: 1),
                tail + Point(x: 7, y: 1),
                tail + Point(x: 10, y: 1),
                tail + Point(x: 13, y: 1),
                tail + Point(x: 16, y: 1),
            ]
        }
    }
}

public extension Day20 {
    func printTileGrid(_ tiles: [Point: Tile], size: Int) {
        var grid = [[String]]()
        
        for y in 0..<size {
            var items = [String]()
            for x in 0..<size {
                let point = Point(x: x, y: y)
                items.append(String(tiles[point]!.id))
            }
            grid.append(items)
        }
        
        grid = flip(grid: grid)
        grid = rotate(grid)
        grid = rotate(grid)
        grid = rotate(grid)
        
        draw(grid, separator: ",")
    }
    
    func draw(_ grid: [[String]], separator: String = "") {
        for row in grid {
            print(row.joined(separator: separator))
        }
        print()
    }
    
    func rotate(_ grid: [[String]]) -> [[String]] {
        let size = grid.count
        return (0..<size).map { x in
            (0..<size).map { y in
                grid[size - 1 - y][x]
            }
        }
    }
    
    func orientAndScanForMonsters(_ grid: inout [[String]]) -> Int {
        let monster = SeaMonster()
        var matches = scanForMonsters(&grid, monster)
        if matches == 0 {
            grid = flip(grid: grid)
            matches = scanForMonsters(&grid, monster)
        }
        return matches
    }
    
    func scanForMonsters(_ grid: inout [[String]], _ monster: Day20.SeaMonster) -> Int {
        var matches = 0
        for _ in 0..<4 {
            for y in 0..<grid.count {
                let line = grid[y].joined()
                let match = monster.regex.matches(in: line)
                for match in match {
                    let x = match.range.lowerBound.utf16Offset(in: line)
                    let tail = Point(x: x, y: y)
                    if monster.allPoints(from: tail)
                        .first(where: { grid[$0.y][$0.x] != "#" }) != nil {
                        break
                    }
                    matches += 1
                }
            }
            if matches > 0 {
                break
            }
            
            grid = rotate(grid)
        }
        return matches
    }
    
    func constructBigGrid(_ tiles: [Point: Tile], size: Int) -> [[String]] {
        let smallerSize = tiles.first!.value.data.count
        let gridSize = size*smallerSize
        var grid: [[String]] = Array(repeating: Array(repeating: ".", count: gridSize), count: gridSize)

        for y in 0..<size {
            for x in 0..<size {
                let point = Point(x: x, y: y)
                let tile = tiles[point]!
                let edgeless = tile.data
                for y2 in 0..<smallerSize {
                    for x2 in 0..<smallerSize {
                        let character = edgeless[y2][x2]
                        let gp = Point(x: (x * smallerSize) + x2, y: (y * smallerSize) + y2)
                        grid[gp.y][gp.x] = String(character)
                    }
                }
            }
        }
        return grid
    }
    
    func indexOf(_ tile: Tile, items: [Tile]) -> Int {
        return items.enumerated().first(where: { $0.1.id == tile.id })!.0
    }
    
    func flip(grid: [[String]]) -> [[String]] {
        var grid = grid
        for y in 0..<grid.count {
            grid[y] = grid[y].reversed()
        }
        return grid
    }
    
    func solveJigsaw(_ size: Int, input: [Tile]) -> [Point: Tile] {
        let sides = allSides(input)
        var (cornerTiles, edgeTiles) = self.cornerAndEdgeTiles(input, sides: sides)
        var middleTiles = input.filter { !cornerTiles.contains($0) && !edgeTiles.contains($0) }
        var topLeft = input.first(where: { $0.id == cornerTiles.first!.id })!
        while sides[topLeft.top]!.count != 1 || sides[topLeft.left]!.count != 1 {
            topLeft = topLeft.rotate
        }

        var tiles = [Point: Tile]()
        tiles[.zero] = topLeft
        
        cornerTiles.remove(at: indexOf(topLeft, items: cornerTiles))
        
        // fill in top row
        for x in 1..<size-1 {
            let point = Point(x: x, y: 0)
            let options = tiles[point + Position.l.point]!
            let possible = findTiles(top: nil, left: options, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible, items: edgeTiles))
        }
        
        // top right corner
        var point = Point(x: size-1, y: 0)
        var options = tiles[point + Position.l.point]!
        var possible = findTiles(top: nil, left: options, tiles: cornerTiles)
        tiles[point] = possible
        cornerTiles.remove(at: indexOf(possible, items: cornerTiles))
        
        // fill in left column
        for y in 1..<size-1 {
            let point = Point(x: 0, y: y)
            let options = tiles[point + Position.t.point]!
            let possible = findTiles(top: options, left: nil, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible, items: edgeTiles))
        }
        
        // bottom left corner
        point = Point(x: 0, y: size-1)
        options = tiles[point + Position.t.point]!
        possible = findTiles(top: options, left: nil, tiles: cornerTiles)
        tiles[point] = possible
        cornerTiles.remove(at: indexOf(possible, items: cornerTiles))
        
        // fill in right column
        for y in 1..<size-1 {
            let point = Point(x: size-1, y: y)
            let options = tiles[point + Position.t.point]!
            let possible = findTiles(top: options, left: nil, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible, items: edgeTiles))
        }
        
        // fill in bottom row
        for x in 1..<size-1 {
            let point = Point(x: x, y: size-1)
            let options = tiles[point + Position.l.point]!
            let possible = findTiles(top: nil, left: options, tiles: edgeTiles)
            tiles[point] = possible
            edgeTiles.remove(at: indexOf(possible, items: edgeTiles))
        }
        
        // bottom right corner
        point = Point(x: size-1, y: size-1)
        options = tiles[point + Position.l.point]!
        possible = findTiles(top: nil, left: options, tiles: cornerTiles)
        tiles[point] = possible
        cornerTiles.remove(at: indexOf(possible, items: cornerTiles))
        
        // middle tiles
        for y in 1..<size-1 {
            for x in 1..<size-1 {
                let point = Point(x: x, y: y)
                let leftOptions = tiles[point + Position.l.point]!
                let topOptions = tiles[point + Position.t.point]!
                let possible = findTiles(top: topOptions, left: leftOptions, tiles: middleTiles)
                tiles[point] = possible
                middleTiles.remove(at: indexOf(possible, items: middleTiles))
            }
        }
        return tiles
    }

    func constructGrid(_ tiles: [Point: Tile], size: Int) -> [[String]] {
        let smallerSize = tiles.first!.value.edgeless.count
        let gridSize = size*smallerSize
        var grid: [[String]] = Array(repeating: Array(repeating: ".", count: gridSize), count: gridSize)

        for y in 0..<size {
            for x in 0..<size {
                let point = Point(x: x, y: y)
                let tile = tiles[point]!
                let edgeless = tile.edgeless
                for y2 in 0..<smallerSize {
                    for x2 in 0..<smallerSize {
                        let character = edgeless[y2][x2]
                        let gp = Point(x: (x * smallerSize) + x2, y: (y * smallerSize) + y2)
                        grid[gp.y][gp.x] = String(character)
                    }
                }
            }
        }
        return grid
    }
    
    func findTiles(top: Tile?, left: Tile?, tiles: [Tile]) -> Tile {
        var visibleSides = Set<String>()
        
        if let top = top {
            visibleSides.insert(top.bottom)
        }
        
        if let left = left {
            visibleSides.insert(left.right)
        }
        
        let tile = tiles.first(where: { $0.sides.intersection(visibleSides).count >= min(2, visibleSides.count) })!
        return rotate(tile, top: top?.bottom, left: left?.right)
    }
    
    func rotate(_ tile: Tile, top: String?, left: String?) -> Tile {
        var tile = tile
        func rotate() -> Tile? {
            for _ in 0..<4 {
                if (top == nil || top == tile.top) && (left == nil || left == tile.left) {
                    return tile
                }
                tile = tile.rotate
            }
            return nil
        }
        if let tile = rotate() {
            return tile
        }
        tile = tile.flip
        return rotate()!
    }
    
    func allSides(_ input: [Tile]) -> [String: [Tile]] {
        var sides = [String: [Tile]]()
        for tile in input {
            for side in tile.sides {
                var tiles = sides[side, default: []]
                tiles.append(tile)
                sides[side] = tiles
            }
        }
        return sides
    }
    
    func cornerAndEdgeTiles(_ input: [Tile], sides: [String: [Tile]]) -> ([Tile], [Tile]) {
        var cornerTiles = [Tile]()
        var edgeTiles = [Tile]()
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
            } else if count1 == 1 && count2 == 3 {
                edgeTiles.append(tile)
            }
        }
        return (cornerTiles, edgeTiles)
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
        
        if !data.isEmpty {
            try processLine("")
        }
        
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
        
        public var sides: Set<String> {
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
            let size = data.count
            for x in 0..<size {
                var line = ""
                for y in 0..<size {
                    line.append(String(data[size - 1 - y][x]))
                }
                rotatedData.append(line)
            }
            
            return Tile(id: id, data: rotatedData)
        }
        
        public func edge(_ direction: CompassDirection) -> String {
            switch direction {
            case .n: return top
            case .e: return right
            case .s: return bottom
            case .w: return bottom
            }
        }
        
        public func edgeFlipped(_ direction: CompassDirection) -> String {
            return String(edge(direction).reversed())
        }
        
        public var edgeless: [String] {
            var lines = [String]()
            let size = data.count
            for y in 1..<size-1 {
                let oldLine = data[y]
                var line = ""
                for x in 1..<size-1 {
                    line.append(String(oldLine[x]))
                }
                lines.append(line)
            }
            return lines
        }
    }
}
