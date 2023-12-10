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
        
    fileprivate func fillWithOutside(_ pointsToFill: inout Set<Point>, _ grid2: inout Grid<Day10.Tiles>) {
        while let point = pointsToFill.popFirst() {
            grid2.items[grid2.index(for: point)] = .outside
            for nextPoint in point.neighbors(max: grid2.bottomRight) {
                if grid2[nextPoint] == .ground {
                    pointsToFill.insert(nextPoint)
                }
            }
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = parse(input)
        let startPoint = grid.point(for: grid.items.firstIndex(of: .start)!)
        var lhs = [startPoint]
        var rhs = [startPoint]
        
        findValidAdjacentStartTiles(grid, startPoint, &lhs, &rhs)
        findFurthestPoint(&lhs, &rhs, grid)
        
        var newItems = Array(repeating: Tiles.ground, count: grid.items.count)
        for point in lhs {
            let index = grid.index(for: point)
            newItems[index] = grid[point]
        }
        
        for point in rhs {
            let index = grid.index(for: point)
            newItems[index] = grid[point]
        }
        
        var grid2 = Grid<Tiles>(columns: grid.columns, items: newItems)
        var firstEdgeTile = Point(-1, -1)
        
        // replace `start`
        switch (lhs[1], rhs[1]) {
            // northSouth
            case (startPoint.up(), startPoint.down()), (startPoint.down(), startPoint.up()):
                grid2.items[grid2.index(for: startPoint)] = .northSouth
                
            // eastWest
            case (startPoint.left(), startPoint.right()), (startPoint.right(), startPoint.left()):
                grid2.items[grid2.index(for: startPoint)] = .eastWest
                
            // northEast
            case (startPoint.up(), startPoint.right()), (startPoint.right(), startPoint.up()):
                grid2.items[grid2.index(for: startPoint)] = .northEast
                
            // northWest
            case (startPoint.up(), startPoint.left()), (startPoint.left(), startPoint.up()):
                grid2.items[grid2.index(for: startPoint)] = .northWest
                
            // southWest
            case (startPoint.down(), startPoint.left()), (startPoint.left(), startPoint.down()):
                grid2.items[grid2.index(for: startPoint)] = .southWest
                
            // southEast
            case (startPoint.down(), startPoint.right()), (startPoint.right(), startPoint.down()):
                grid2.items[grid2.index(for: startPoint)] = .southEast
                
            default:
                assertionFailure("Something isn't right!")
        }
        
        // Fill in outside
        var pointsToFill = Set<Point>()
        for x in (0..<grid.columns) {
            var point = Point(x: x, y: 0)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
            
            point = Point(x: x, y: grid.rows-1)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
        }
        
        for y in (0..<grid.rows) {
            var point = Point(x: 0, y: y)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
            
            point = Point(x: grid.columns-1, y: y)
            
            if grid2[point] == .ground {
                pointsToFill.insert(point)
            } else if firstEdgeTile == Point(-1, -1), point != startPoint {
                firstEdgeTile = point
            }
        }
        
        fillWithOutside(&pointsToFill, &grid2)
        
        var edges: Set<Position> = []
        let tile = grid2[firstEdgeTile]
        /*
         tl, t, tr
         l , m,  r
         bl, b, br
         
         `m` is the current point
         Find the outer edge
         */
        switch tile {
            case .northSouth:
                if firstEdgeTile.left().x <= 0 {
                    edges = [.tl, .l, .bl]
                } else {
                    edges = [.tr, .r, .br]
                }
                
            case .eastWest:
                if firstEdgeTile.up().y <= 0 {
                    edges = [.tl, .t, .tr]
                } else {
                    edges = [.bl, .b, .br]
                }
                
            case .northEast:
                if firstEdgeTile.left().x <= 0 || firstEdgeTile.down().y >= grid2.rows {
                    edges = [.tl, .l, .bl, .b, .br]
                } else {
                    edges = [.tr]
                }
                
            case .northWest:
                if firstEdgeTile.right().x >= grid2.columns || firstEdgeTile.down().y >= grid2.rows {
                    edges = [.tr, .r, .br, .b, .bl]
                } else {
                    edges = [.tl]
                }
                
            case .southWest:
                if firstEdgeTile.up().y <= 0 || firstEdgeTile.right().x >= grid2.columns  {
                    edges = [.tl, .t, .tr, .r, .br]
                } else {
                    edges = [.bl]
                }
                
            case .southEast:
                if firstEdgeTile.up().y <= 0 || firstEdgeTile.left().x <= 0  {
                    edges = [.tl, .t, .tr, .l, .bl]
                } else {
                    edges = [.br]
                }
                
            default:
                assertionFailure("What happened? Invalid edge tile")
        }
        
        for point in rhs.reversed() {
            guard point != startPoint else { continue }
            lhs.append(point)
        }
        
        let startIndex = lhs.firstIndex(of: firstEdgeTile)!
        var index = startIndex
        
        while true {
            let previousPoint = lhs[index]
            index += 1
            if index >= lhs.count {
                index = 0
            }
            let point = lhs[index]
            let tile = grid2[point]
            
            switch tile {
                case .northSouth:
                    if previousPoint == point.up() {
                        if edges.contains([.bl]) {
                            edges = [.tl, .l, .bl]
                        } else {
                            edges = [.tr, .r, .br]
                        }
                    } else {
                        if edges.contains([.tl]) {
                            edges = [.tl, .l, .bl]
                        } else {
                            edges = [.tr, .r, .br]
                        }
                    }
                    
                case .eastWest:
                    if previousPoint == point.left() {
                        if edges.contains([.tr]) {
                            edges = [.tl, .t, .tr]
                        } else {
                            edges = [.bl, .b, .br]
                        }
                    } else {
                        if edges.contains([.tl]) {
                            edges = [.tl, .t, .tr]
                        } else {
                            edges = [.bl, .b, .br]
                        }
                    }
                    
                case .northEast:
                    if previousPoint == point.up() {
                        if edges.contains([.br]) {
                            edges = [.tr]
                        } else {
                            edges = [.tl, .l, .bl, .b, .br]
                        }
                    } else {
                        if edges.contains([.tl]) {
                            edges = [.tr]
                        } else {
                            edges = [.tl, .l, .bl, .b, .br]
                        }
                    }
                    
                case .northWest:
                    if previousPoint == point.up() {
                        if edges.contains([.bl]) {
                            edges = [.tl]
                        } else {
                            edges = [.tr, .r, .br, .b, .bl]
                        }
                    } else {
                        if edges.contains([.tr]) {
                            edges = [.tl]
                        } else {
                            edges = [.tr, .r, .br, .b, .bl]
                        }
                    }
                    
                case .southWest:
                    if previousPoint == point.down() {
                        if edges.contains([.tl]) {
                            edges = [.bl]
                        } else {
                            edges = [.tl, .t, .tr, .r, .br]
                        }
                    } else {
                        if edges.contains([.br]) {
                            edges = [.bl]
                        } else {
                            edges = [.tl, .t, .tr, .r, .br]
                        }
                    }
                    
                case .southEast:
                    if previousPoint == point.down() {
                        if edges.contains([.tr]) {
                            edges = [.br]
                        } else {
                            edges = [.tr, .t, .tl, .l, .bl]
                        }
                    } else {
                        if edges.contains([.bl]) {
                            edges = [.br]
                        } else {
                            edges = [.tr, .t, .tl, .l, .bl]
                        }
                    }
                    
                case .start:
                    break
                    
                default:
                    assertionFailure("What happened? Invalid edge tile")
            }
            
//            print()
//            print(point, tile.rawValue)
//            printEdges(edges, tile)

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
        
        fillWithOutside(&pointsToFill, &grid2)
        
//        grid2.draw()
        
        return grid2.items.filter({ $0 == .ground }).count
    }
    
    func printEdges(_ edges: Set<Position>, _ tile: Tiles) {
        print("\(edges.contains(.tl) ? "⚪️" : "⚫️")\(edges.contains(.t) ? "⚪️" : [.northSouth, .northEast, .northWest].contains(tile) ? "🔴" : "⚫️")\(edges.contains(.tr) ? "⚪️" : "⚫️")")
        print("\(edges.contains(.l) ? "⚪️" : [.eastWest, .northWest, .southWest].contains(tile) ? "🔴" : "⚫️")🔴\(edges.contains(.r) ? "⚪️" : [.eastWest, .northEast, .southEast].contains(tile) ? "🔴" : "⚫️")")
        print("\(edges.contains(.bl) ? "⚪️" : "⚫️")\(edges.contains(.b) ? "⚪️" : [.northSouth, .southEast, .southWest].contains(tile) ? "🔴" : "⚫️")\(edges.contains(.br) ? "⚪️" : "⚫️")")
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
    func findValidAdjacentStartTiles(_ grid: Grid<Day10.Tiles>, _ startPoint: Point, _ lhs: inout [Point], _ rhs: inout [Point]) {
        if startPoint.up().isValid(max: grid.bottomRight), [.northSouth, .southWest, .southEast].contains(grid[startPoint.up()]) {
            lhs.append(startPoint.up())
        }
        
        if startPoint.down().isValid(max: grid.bottomRight), [.northSouth, .northEast, .northWest].contains(grid[startPoint.down()]) {
            if lhs.count == 1 {
                lhs.append(startPoint.down())
            } else {
                rhs.append(startPoint.down())
            }
        }
        
        if startPoint.left().isValid(max: grid.bottomRight), [.eastWest, .northEast, .southEast].contains(grid[startPoint.left()]) {
            if lhs.count == 1 {
                lhs.append(startPoint.left())
            } else {
                rhs.append(startPoint.left())
            }
        }
        
        if startPoint.right().isValid(max: grid.bottomRight), [.eastWest, .northWest, .southWest].contains(grid[startPoint.right()]) {
            if lhs.count == 1 {
                lhs.append(startPoint.right())
            } else {
                rhs.append(startPoint.right())
            }
        }
    }
    
    func findFurthestPoint(_ lhs: inout [Point], _ rhs: inout [Point], _ grid: Grid<Day10.Tiles>) {
        while lhs.last! != rhs.last! {
            let leftPoint = lhs[lhs.count - 1]
            let previousLeftPoint = lhs[lhs.count - 2]
            let left = grid[leftPoint]
            let nextLeftPoint = left.points(for: leftPoint).filter({ $0 != previousLeftPoint }).first!
            lhs.append(nextLeftPoint)
            
            let rightPoint = rhs[rhs.count - 1]
            let previousRightPoint = rhs[rhs.count - 2]
            let right = grid[rightPoint]
            let nextRightPoint = right.points(for: rightPoint).filter({ $0 != previousRightPoint }).first!
            rhs.append(nextRightPoint)
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
