import Foundation
import StandardLibraries

public struct Day25 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        // Divide input into boards
        var boards = [[String]]()
        var board = [String]()
        for line in input {
            if line.isEmpty {
                boards.append(board)
                board = []
            } else {
                board.append(line)
            }
        }
        boards.append(board)
        board = []

        // Convert boards to locks and keys
        var locks = [[Int]]()
        var keys = [[Int]]()
        for board in boards {
            let grid = Grid<String>(board)
            assert(grid.rows == 7)
            if self.isLock(grid) {
                locks.append(calculateLock(grid))
            } else {
                keys.append(calculateKey(grid))
            }
        }

        // Calculate lock and key combinations that fit
        var results = 0
        for key in keys {
            for lock in locks {
                if canFit(key: key, lock: lock) {
                    results += 1
                }
            }
        }
        
        return results
    }
    
    func isLock(_ grid: Grid<String>) -> Bool {
        for x in 0..<grid.columns {
            if grid[x, 0] != "#" {
                return false
            }
        }
        return true
    }
    
    func calculateKey(_ grid: Grid<String>) -> [Int] {
        var results = [Int]()
        for x in 0..<grid.columns {
            var column = 0
            for y in 0..<grid.rows {
                if grid[x, y] == "." {
                    column += 1
                } else {
                    break
                }
            }
            results.append(7 - column)
        }
        return results
    }
    
    func calculateLock(_ grid: Grid<String>) -> [Int] {
        var results = [Int]()
        for x in 0..<grid.columns {
            var column = 0
            for y in 0..<grid.rows {
                if grid[x, y] == "#" {
                    column += 1
                } else {
                    break
                }
            }
            results.append(column)
        }
        return results
    }
    
    func canFit(key: [Int], lock: [Int]) -> Bool {
        for i in 0..<key.count {
            if key[i] + lock[i] > 7 { return false }
        }
        return true
    }
}
