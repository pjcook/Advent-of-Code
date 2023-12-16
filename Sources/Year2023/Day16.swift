import Foundation
import StandardLibraries

public struct Day16 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        let grid = parse(input)
        return calculateEnergizedTileCount(grid: grid, start: MapEntry(point: Point(-1,0), direction: .right))
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = parse(input)
        var largest = 0
        
        for y in (0..<grid.rows) {
            let result = calculateEnergizedTileCount(grid: grid, start: MapEntry(point: Point(-1,y), direction: .right))
            largest = max(largest, result)
            
            let result2 = calculateEnergizedTileCount(grid: grid, start: MapEntry(point: Point(grid.rows,y), direction: .left))
            largest = max(largest, result2)
        }
        
        for x in (0..<grid.columns) {
            let result = calculateEnergizedTileCount(grid: grid, start: MapEntry(point: Point(x,-1), direction: .down))
            largest = max(largest, result)
            
            let result2 = calculateEnergizedTileCount(grid: grid, start: MapEntry(point: Point(x,grid.columns), direction: .up))
            largest = max(largest, result2)
        }
        
        return largest
    }
    
    func calculateEnergizedTileCount(grid: Grid<Tile>, start: MapEntry) -> Int {
        var energized = Set<MapEntry>()
        var toProcess = Set<MapEntry>()
        toProcess.insert(start)
        
        while let entry = toProcess.popFirst() {
            guard !energized.contains(entry) else { continue }
            
            energized.insert(entry)
            let nextPoint = entry.point + entry.direction.point
            
            guard nextPoint.isValid(max: grid.bottomRight) else { continue }
            
            switch grid[nextPoint] {
                    
                case .empty:    // "."
                    toProcess.insert(MapEntry(point: nextPoint, direction: entry.direction))
                    
                case .splitVertical:    // "|"
                    if [.left, .right].contains(entry.direction) {
                        toProcess.insert(MapEntry(point: nextPoint, direction: .up))
                        toProcess.insert(MapEntry(point: nextPoint, direction: .down))
                    } else {
                        toProcess.insert(MapEntry(point: nextPoint, direction: entry.direction))
                    }
                    
                case .splitHorizontal:  // "-"
                    if [.up, .down].contains(entry.direction) {
                        toProcess.insert(MapEntry(point: nextPoint, direction: .left))
                        toProcess.insert(MapEntry(point: nextPoint, direction: .right))
                    } else {
                        toProcess.insert(MapEntry(point: nextPoint, direction: entry.direction))
                    }
                    
                case .mirrorRight:  // "/"
                    switch entry.direction {
                        case .up:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .right))
                        case .down:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .left))
                        case .left:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .down))
                        case .right:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .up))
                    }
                    
                case .mirrorLeft:   // "\"
                    switch entry.direction {
                        case .up:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .left))
                        case .down:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .right))
                        case .left:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .up))
                        case .right:
                            toProcess.insert(MapEntry(point: nextPoint, direction: .down))
                    }
            }
        }
        
        var results = Set<Point>()
        for entry in energized {
            results.insert(entry.point)
        }
        return results.count - 1
    }
    
    enum Tile: String, CustomStringConvertible {
        case empty = "."
        case splitVertical = "|"
        case splitHorizontal = "-"
        case mirrorRight = "/"
        case mirrorLeft = "\\"
        
        var description: String { rawValue }
    }
    
    struct MapEntry: Hashable {
        let point: Point
        let direction: Direction
    }
}

extension Day16 {
    func parse(_ input: [String]) -> Grid<Tile> {
        var items = [Tile]()
        
        for row in input {
            row.forEach { items.append(Tile(rawValue: String($0))!) }
        }
        
        return Grid<Tile>(columns: input[0].count, items: items)
    }
}
