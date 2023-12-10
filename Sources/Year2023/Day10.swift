import Foundation
import StandardLibraries

public struct Day10 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = parse(input)
        let startPoint = grid.point(for: grid.items.firstIndex(of: .start)!)
        var lhs = [startPoint]
        var rhs = [startPoint]
        
        findValidAdjacentStartTiles(grid, startPoint, &lhs, &rhs)
        findFurthestPoint(&lhs, &rhs, grid)
        
        return lhs.count-1
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = parse(input)
        let startPoint = grid.point(for: grid.items.firstIndex(of: .start)!)
        var lhs = [startPoint]
        var rhs = [startPoint]
        
        findValidAdjacentStartTiles(grid, startPoint, &lhs, &rhs)
        findFurthestPoint(&lhs, &rhs, grid)
        
        var newItems = Array(repeating: Tiles.ground, count: grid.items.count)
        rhs.removeFirst()   // remove value that's already in `lhs`
        rhs.removeLast()    // remove value that's already in `lhs`
        lhs.append(contentsOf: rhs.reversed())
        for point in lhs {
            let index = grid.index(for: point)
            newItems[index] = grid[point]
        }
        
        var grid2 = Grid<Tiles>(columns: grid.columns, items: newItems)
        replaceStartTile(lhs, rhs, startPoint, &grid2)
        
        // Fill in outside
        var (pointsToFill, firstEdgeTile) = findOuterEdgeGroundTilesAndFirstEdgeTile(grid2, startPoint)
        fillWithOutside(&pointsToFill, &grid2)
        findHiddenOuterTiles(firstEdgeTile, lhs, grid2, &pointsToFill)
        fillWithOutside(&pointsToFill, &grid2)
        
        return grid2.items.filter({ $0 == .ground }).count
    }
    
    enum Tiles: Character, CustomStringConvertible {
        case northSouth = "|"
        case eastWest = "-"
        case northEast = "L"
        case northWest = "J"
        case southWest = "7"
        case southEast = "F"
        case ground = "."
        case start = "S"
        case outside = "O"
        case inside = "I"
                
        func points(for point: Point) -> [Point] {
            switch self {
                case .northSouth:
                    [point.up(), point.down()]
                case .eastWest:
                    [point.right(), point.left()]
                case .northEast:
                    [point.up(), point.right()]
                case .northWest:
                    [point.up(), point.left()]
                case .southWest:
                    [point.down(), point.left()]
                case .southEast:
                    [point.down(), point.right()]
                default:
                    [point]
            }
        }

        var description: String {
            String(rawValue)
        }
    }
}

extension Day10 {
    func findHiddenOuterTiles(_ firstEdgeTile: Point, _ lhs: [Point], _ grid2: Grid<Day10.Tiles>, _ pointsToFill: inout Set<Point>) {
        let startIndex = lhs.firstIndex(of: firstEdgeTile)!
        var edges: Set<Position> = calculateInitialTileEdges(firstEdgeTile, grid2)

        var index = startIndex
        
        while true {
            let previousPoint = lhs[index]
            index = incrementIndex(index, maxIndex: lhs.count)
            let point = lhs[index]
            
            edges = calculateTileOuterEdges(previousPoint, point, grid2, edges)
            
            let outerPositions = edges.map { point + $0.point }
            for neighbor in point.neighbors(max: grid2.bottomRight) {
                if outerPositions.contains(neighbor), grid2[neighbor] == .ground {
                    pointsToFill.insert(neighbor)
                }
            }
            
            if index == startIndex {
                break
            }
        }
    }
    
    func incrementIndex(_ index: Int, maxIndex: Int) -> Int {
        let index = index + 1
        if index >= maxIndex {
            return 0
        }
        return index
    }
    
    func calculateTileOuterEdges(_ previousPoint: Point, _ point: Point, _ grid2: Grid<Tiles>, _ edges: Set<Position>) -> Set<Position> {
        switch (grid2[point], previousPoint) {
            case (.northSouth, point.up()):
                return edges.contains([.bl]) ? [.tl, .l, .bl] : [.tr, .r, .br]

            case (.northSouth, _):
                return edges.contains([.tl]) ? [.tl, .l, .bl] : [.tr, .r, .br]
                
            case (.eastWest, point.left()):
                return edges.contains([.tr]) ? [.tl, .t, .tr] : [.bl, .b, .br]

            case (.eastWest, _):
                return edges.contains([.tl]) ? [.tl, .t, .tr] : [.bl, .b, .br]
                
            case (.northEast, point.up()):
                return edges.contains([.br]) ? [.tr] : [.tl, .l, .bl, .b, .br]

            case (.northEast, _):
                return edges.contains([.tl]) ? [.tr] : [.tl, .l, .bl, .b, .br]
                
            case (.northWest, point.up()):
                return edges.contains([.bl]) ? [.tl] : [.tr, .r, .br, .b, .bl]

            case (.northWest, _):
                return edges.contains([.tr]) ? [.tl] : [.tr, .r, .br, .b, .bl]
                
            case (.southWest, point.down()):
                return edges.contains([.tl]) ? [.bl] : [.tl, .t, .tr, .r, .br]

            case (.southWest, _):
                return edges.contains([.br]) ? [.bl] : [.tl, .t, .tr, .r, .br]
                
            case (.southEast, point.down()):
                return edges.contains([.tr]) ? [.br] : [.tr, .t, .tl, .l, .bl]

            case (.southEast, _):
                return edges.contains([.bl]) ? [.br] : [.tr, .t, .tl, .l, .bl]

            default:
                assertionFailure("What happened? Invalid edge tile")
        }
        return []
    }
    
    func calculateInitialTileEdges(_ firstEdgeTile: Point, _ grid2: Grid<Day10.Tiles>) -> Set<Position> {
        switch grid2[firstEdgeTile] {
            case .northSouth:
                return firstEdgeTile.left().x <= 0 ? [.tl, .l, .bl] : [.tr, .r, .br]
                
            case .eastWest:
                return firstEdgeTile.up().y <= 0 ? [.tl, .t, .tr] : [.bl, .b, .br]
                
            case .northEast:
                return firstEdgeTile.left().x <= 0 || firstEdgeTile.down().y >= grid2.rows ? [.tl, .l, .bl, .b, .br] : [.tr]
                
            case .northWest:
                return firstEdgeTile.right().x >= grid2.columns || firstEdgeTile.down().y >= grid2.rows ? [.tr, .r, .br, .b, .bl] : [.tl]
                
            case .southWest:
                return firstEdgeTile.up().y <= 0 || firstEdgeTile.right().x >= grid2.columns ? [.tl, .t, .tr, .r, .br] : [.bl]
                
            case .southEast:
                return firstEdgeTile.up().y <= 0 || firstEdgeTile.left().x <= 0  ? [.tl, .t, .tr, .l, .bl] : [.br]
                
            default:
                assertionFailure("What happened? Invalid edge tile")
        }
        return []
    }
    
    func findOuterEdgeGroundTilesAndFirstEdgeTile(_ grid2: Grid<Tiles>, _ startPoint: Point) -> (Set<Point>, Point) {
        var pointsToFill = Set<Point>()
        var firstEdgeTile = Point(-1, -1)
        for x in (0..<grid2.columns) {
            var point = Point(x: x, y: 0)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
            
            point = Point(x: x, y: grid2.rows-1)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
        }
        
        for y in (0..<grid2.rows) {
            var point = Point(x: 0, y: y)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
            
            point = Point(x: grid2.columns-1, y: y)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
        }
        return (pointsToFill, firstEdgeTile)
    }
    
    func replaceStartTile(_ lhs: [Point], _ rhs: [Point], _ startPoint: Point, _ grid2: inout Grid<Day10.Tiles>) {
        // replace `start`
        grid2.items[grid2.index(for: startPoint)] = switch (lhs[1], rhs[0]) {
                // northSouth
            case (startPoint.up(), startPoint.down()), (startPoint.down(), startPoint.up()):
                .northSouth
                
                // eastWest
            case (startPoint.left(), startPoint.right()), (startPoint.right(), startPoint.left()):
                .eastWest
                
                // northEast
            case (startPoint.up(), startPoint.right()), (startPoint.right(), startPoint.up()):
                .northEast
                
                // northWest
            case (startPoint.up(), startPoint.left()), (startPoint.left(), startPoint.up()):
                .northWest
                
                // southWest
            case (startPoint.down(), startPoint.left()), (startPoint.left(), startPoint.down()):
                .southWest
                
                // southEast
            case (startPoint.down(), startPoint.right()), (startPoint.right(), startPoint.down()):
                .southEast
                
            default:
//                assertionFailure("Something isn't right!")
                .start
        }
    }
    
    func fillWithOutside(_ pointsToFill: inout Set<Point>, _ grid2: inout Grid<Day10.Tiles>) {
        while let point = pointsToFill.popFirst() {
            grid2.items[grid2.index(for: point)] = .outside
            for nextPoint in point.neighbors(max: grid2.bottomRight) {
                if grid2[nextPoint] == .ground {
                    pointsToFill.insert(nextPoint)
                }
            }
        }
    }
    
    func findValidAdjacentStartTiles(_ startPoint: Point, _ grid: Grid<Day10.Tiles>, _ validOptions: [Tiles], _ lhs: inout [Point], _ rhs: inout [Point]) {
        if startPoint.isValid(max: grid.bottomRight), validOptions.contains(grid[startPoint]) {
            if lhs.count == 1 {
                lhs.append(startPoint)
            } else {
                rhs.append(startPoint)
            }
        }
    }
    
    func findValidAdjacentStartTiles(_ grid: Grid<Day10.Tiles>, _ startPoint: Point, _ lhs: inout [Point], _ rhs: inout [Point]) {
        findValidAdjacentStartTiles(startPoint.up(), grid, [.northSouth, .southWest, .southEast], &lhs, &rhs)
        findValidAdjacentStartTiles(startPoint.down(), grid, [.northSouth, .northEast, .northWest], &lhs, &rhs)
        findValidAdjacentStartTiles(startPoint.left(), grid, [.eastWest, .northEast, .southEast], &lhs, &rhs)
        findValidAdjacentStartTiles(startPoint.right(), grid, [.eastWest, .northWest, .southWest], &lhs, &rhs)
    }
    
    func nextPoint(_ list: inout [Point], _ grid: Grid<Day10.Tiles>) {
        let currentPoint = list[list.count - 1]
        let previousPoint = list[list.count - 2]
        let tile = grid[currentPoint]
        let nextPoint = tile.points(for: currentPoint).filter({ $0 != previousPoint }).first!
        list.append(nextPoint)
    }
    
    func findFurthestPoint(_ lhs: inout [Point], _ rhs: inout [Point], _ grid: Grid<Day10.Tiles>) {
        while lhs.last! != rhs.last! {
            nextPoint(&lhs, grid)
            nextPoint(&rhs, grid)
        }
    }
}

extension Day10 {
    func parse(_ input: [String]) -> Grid<Tiles> {
        var items = [Tiles]()
        let columns = input[0].count
        for line in input {
            for c in line {
                items.append(Tiles(rawValue: c)!)
            }
        }
        return Grid(columns: columns, items: items)
    }
}
