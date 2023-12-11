import Foundation
import StandardLibraries

public struct Day11 {
    public init() {}
    
    typealias ExpandedRows = [Int]
    typealias ExpandedColumns = [Int]
    
    public func solve(_ input: [String], multiplier: Int) -> Int {
        let grid = Grid<String>(input)
        let galaxies = findGalaxies(grid)
        let (expandedColumns, expandedRows) = calculateExpandingColumnsRows(galaxies, columns: grid.columns, rows: grid.rows)
        let galaxyPairs = pairGalaxies(galaxies)
        return calculateSumOfManhattanDistances(galaxyPairs, expandedRows, expandedColumns, multiplier)
    }
}

extension Day11 {
    func calculateSumOfManhattanDistances(_ galaxyPairs: [(Point, Point)], _ expandedRows: Day11.ExpandedRows, _ expandedColumns: Day11.ExpandedColumns, _ multiplier: Int) -> Int {
        var sum = 0
        
        for (a, b) in galaxyPairs {
            let distance = a.manhattanDistance(to: b)
            let additionalRows = countFilteredOptions(expandedRows, a: a.y, b: b.y)            
            let additionalColumns = countFilteredOptions(expandedColumns, a: a.x, b: b.x)
            
            sum += distance + (additionalRows * multiplier) + (additionalColumns * multiplier) - (additionalColumns + additionalRows)
        }
        
        return sum
    }
    
    func countFilteredOptions(_ options: [Int], a: Int, b: Int) -> Int {
        let minValue = min(a, b)
        let maxValue = max(a, b)
        var count = 0
        guard minValue < options.last!, maxValue > options.first! else { return 0 }
        
        for value in options {
            if value >= minValue, value <= maxValue {
                count += 1
            } else if value > maxValue {
                break
            }
        }
        
        return count
    }
    
    func pairGalaxies(_ galaxies: [Point]) -> [(Point, Point)] {
        var galaxies = galaxies
        var results = [(Point, Point)]()
        
        while let galaxy = galaxies.popLast() {
            for g in galaxies {
                results.append((galaxy, g))
            }
        }
        
        return results
    }
    
    func calculateExpandingColumnsRows(_ galaxies: [Point], columns: Int, rows: Int) -> (ExpandedColumns, ExpandedRows) {
        var rowsToExpand = Set(0..<rows)
        var columnsToExpand = Set(0..<columns)
        
        for galaxy in galaxies {
            rowsToExpand.remove(galaxy.y)
            columnsToExpand.remove(galaxy.x)
        }
        
        return (Array(columnsToExpand).sorted(), Array(rowsToExpand).sorted())
    }
    
    func findGalaxies(_ grid: Grid<String>) -> [Point] {
        var galaxies = [Point]()
        
        for i in (0..<grid.items.count) {
            if grid.items[i] == "#" {
                galaxies.append(grid.point(for: i))
            }
        }
        
        return galaxies
    }
}
