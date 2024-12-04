import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        var results = 0
        let grid = Grid<String>(input)
        let options = ["XMAS", "SAMX"]
        func checkValue(_ value: String) {
            if options.contains(value) {
                results += 1
            }
        }
        
        for x in (0..<grid.columns) {
            for y in (0..<grid.rows) {
                guard grid[x,y] == "X" else { continue }
                // checkHorizontal
                if x-3 >= 0 {
                    let value = "X" + grid[x-1, y] + grid[x-2, y] + grid[x-3, y]
                    checkValue(value)
                }
                
                if x+3 < grid.columns {
                    let value = "X" + grid[x+1, y] + grid[x+2, y] + grid[x+3, y]
                    checkValue(value)
                }
                
                // checkVertical
                if y-3 >= 0 {
                    let value = "X" + grid[x, y-1] + grid[x, y-2] + grid[x, y-3]
                    checkValue(value)
                }
                
                if y+3 < grid.rows {
                    let value = "X" + grid[x, y+1] + grid[x, y+2] + grid[x, y+3]
                    checkValue(value)
                }
                
                // checkDiagonal
                if x-3 >= 0, y-3 >= 0 {
                    let value = "X" + grid[x-1, y-1] + grid[x-2, y-2] + grid[x-3, y-3]
                    checkValue(value)
                }
                
                if x-3 >= 0, y+3 < grid.rows {
                    let value = "X" + grid[x-1, y+1] + grid[x-2, y+2] + grid[x-3, y+3]
                    checkValue(value)
                }
                
                if x+3 < grid.columns, y-3 >= 0 {
                    let value = "X" + grid[x+1, y-1] + grid[x+2, y-2] + grid[x+3, y-3]
                    checkValue(value)
                }
                
                if x+3 < grid.columns, y+3 < grid.rows {
                    let value = "X" + grid[x+1, y+1] + grid[x+2, y+2] + grid[x+3, y+3]
                    checkValue(value)
                }
            }
        }
        
        return results
    }
    
    public func part2(_ input: [String]) -> Int {
        var results = 0
        let grid = Grid<String>(input)
        let options = ["MAS", "SAM"]
        for x in (1..<grid.columns-1) {
            for y in (1..<grid.rows-1) {
                guard grid[x, y] == "A" else { continue }
                
                let value1 = grid[x-1, y-1] + "A" + grid[x+1, y+1]
                let value2 = grid[x+1, y-1] + "A" + grid[x-1, y+1]
                if options.contains(value1), options.contains(value2) {
                    results += 1
                }
            }
        }
        
        return results
    }
}
