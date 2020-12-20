import Foundation
import InputReader
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

        var tiles = [Point: Tile]()
        tiles[.zero] = topLeft
        
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
        
        var largeGrid = constructBigGrid(tiles, size: size)
//        // to reverse the grid use this loop
//        for y in 0..<largeGrid.count {
//            largeGrid[y] = largeGrid[y].reversed()
//        }
        draw(largeGrid)
        
        // Trim tile edges
        // no longer needed, each tile has an edgeless property
        
        // Construct main grid
        var grid = constructGrid(tiles, size: size)
        
        // view grid
//        draw(grid)

        // build sea monster
        let monster = SeaMonster()

        // Orient the grid
        var matches = 0
        for _ in 0..<4 {
            for y in 1..<grid.count-1 {
                let line = grid[y].joined()
                if
                    let match = try? monster.regex.match(line),
                    let x = match.captureGroups.first?.range.lowerBound.utf16Offset(in: line)
                {
                    let tail = Point(x: x, y: y)
                    var points = monster.abovePoints(tailStart: tail)
                    points += monster.belowPoints(tailStart: tail)
                    var count = 0
                    for point in points {
                        if grid[point.y][point.x] == "#" {
                            count += 1
                        } else {
                            break
                        }
                    }
                    if points.count == count {
                        matches += 1
                    }
                }
            }
            if matches > 0 {
                break
            }
            
            grid = rotate(grid)
        }
        if matches == 0 {
            for y in 0..<grid.count {
                grid[y] = grid[y].reversed()
            }

            for _ in 0..<4 {
                for y in 1..<grid.count-1 {
                    let line = grid[y].joined()
                    if
                        let match = try? monster.regex.match(line),
                        let x = match.captureGroups.first?.range.lowerBound.utf16Offset(in: line)
                    {
                        let tail = Point(x: x, y: y)
                        var points = monster.abovePoints(tailStart: tail)
                        points += monster.belowPoints(tailStart: tail)
                        var count = 0
                        for point in points {
                            if grid[point.y][point.x] == "#" {
                                count += 1
                            } else {
                                break
                            }
                        }
                        if points.count == count {
                            matches += 1
                        }
                    }
                }
                if matches > 0 {
                    break
                }
                
                grid = rotate(grid)
            }
        }
        
        let hashesBeforeSearch = grid.reduce(0) {
            $0 + ($1.reduce(0) { $0 + ($1 == "#" ? 1 : 0) })
        }
        
        // Search for sea monsters
        draw(grid)
        for y in 1..<grid.count-1 {
            let line = grid[y].joined()
            if
                let match = try? monster.regex.match(line),
                let x = match.captureGroups.first?.range.lowerBound.utf16Offset(in: line)
            {
                let tail = Point(x: x, y: y)
                var points = monster.abovePoints(tailStart: tail)
                points += monster.belowPoints(tailStart: tail)
                var count = 0
                for point in points {
                    if grid[point.y][point.x] == "#" {
                        count += 1
                    } else {
                        break
                    }
                }
                if points.count == count {
                    let monsterPoints = monster.allPoints(tailStart: tail)
                    for point in monsterPoints {
                        grid[point.y][point.x] = "O"
                    }
                }
            }
        }
        
        draw(grid)
                
        return grid.reduce(0) {
            $0 + ($1.reduce(0) { $0 + ($1 == "#" ? 1 : 0) })
        }
    }
}

public extension Day20 {
    struct SeaMonster {
        public let above  = "                  #"
        public let search = "#    ##    ##    ###"
        public let below  = " #  #  #  #  #  #"
        public let regex = try! RegularExpression(pattern: #"^.*(#....##....##....###).*$"#)
        
        public init() {}
        
        public func abovePoints(tailStart: Point) -> [Point] {
            return [tailStart + Point(x: 18, y: -1)]
        }
        
        public func belowPoints(tailStart: Point) -> [Point] {
            return [
                tailStart + Point(x: 1, y: 1),
                tailStart + Point(x: 4, y: 1),
                tailStart + Point(x: 7, y: 1),
                tailStart + Point(x: 10, y: 1),
                tailStart + Point(x: 13, y: 1),
                tailStart + Point(x: 16, y: 1),
            ]
        }
        
        public func allPoints(tailStart: Point) -> [Point] {
            return [
                tailStart,
                tailStart + Point(x: 5, y: 0),
                tailStart + Point(x: 6, y: 0),
                tailStart + Point(x: 11, y: 0),
                tailStart + Point(x: 12, y: 0),
                tailStart + Point(x: 17, y: 0),
                tailStart + Point(x: 18, y: 0),
                tailStart + Point(x: 19, y: 0),
            ]
            + abovePoints(tailStart: tailStart)
            + belowPoints(tailStart: tailStart)
        }
    }
}

public extension Day20 {
    func draw(_ grid: [[String]]) {
        for row in grid {
            var line = ""
            for value in row {
                line.append(value)
            }
            print(line)
        }
        print()
    }
    
    func rotate(_ grid: [[String]]) -> [[String]] {
        var output = [[String]]()
        let size = grid.count
        
        for x in 0..<size {
            var line = [String]()
            for y in 0..<size {
                line.append((grid[size - 1 - y][x]))
            }
            output.append(line)
        }
        
        return output
    }
    
    func countSeaMonsters(_ grid: [[String]]) -> Int {
        var grid = grid
        let monster = SeaMonster()
        for y in 1..<grid.count-1 {
            let line = grid[y].joined()
            if
                let match = try? monster.regex.match(line),
                let x = match.captureGroups.first?.range.lowerBound.utf16Offset(in: line)
            {
                let tail = Point(x: x, y: y)
                var points = monster.abovePoints(tailStart: tail)
                points += monster.belowPoints(tailStart: tail)
                var count = 0
                for point in points {
                    if grid[point.y][point.x] == "#" {
                        count += 1
                    } else {
                        break
                    }
                }
                if points.count == count {
                    let monsterPoints = monster.allPoints(tailStart: tail)
                    for point in monsterPoints {
                        grid[point.y][point.x] = "O"
                    }
                }
            }
        }
        return grid.reduce(0) {
            $0 + ($1.reduce(0) { $0 + ($1 == "#" ? 1 : 0) })
        }
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
                        grid[gp.y][gp.x] = character
                    }
                }
            }
        }
        return grid
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
                        grid[gp.y][gp.x] = character
                    }
                }
            }
        }
        return grid
    }
    
    func findTiles(top: Tile?, left: Tile?, tiles: [Tile]) -> Tile {
        var existingTiles = Set<Int>()
        var allTop = Set<String>()
        var allLeft = Set<String>()

        var visibleSides = [String]()
        if let top = top {
            visibleSides.append(top.bottom)
            allTop.insert(top.bottom)
            existingTiles.insert(top.id)
        }
        if let left = left {
            visibleSides.append(left.right)
            allLeft.insert(left.right)
            existingTiles.insert(left.id)
        }

        for tile in tiles {
            var count = 0
            for side in visibleSides {
                if tile.sides.contains(side) {
                    count += 1
                }
            }
            if count >= min(2, visibleSides.count) {
                return rotate(tile, top: allTop, left: allLeft)
            }
        }
        assertionFailure("Where is my tile?")
        return Tile(id: -1, data: [])
    }
    
    func rotate(_ tile: Tile, top: Set<String>, left: Set<String>) -> Tile {
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
        assertionFailure("Where is my tile?")
        return Tile(id: -1, data: [])
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
            let size = data.count
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
        
        public var edgeless: [String] {
            var lines = [String]()
            let size = data.count
            for y in 1..<size-1 {
                let oldLine = data[y]
                var line = ""
                for x in 1..<size-1 {
                    line.append(oldLine[x])
                }
                lines.append(line)
            }
            return lines
        }
    }
}
