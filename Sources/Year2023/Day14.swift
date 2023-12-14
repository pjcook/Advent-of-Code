import Foundation
import StandardLibraries

public struct Day14 {
    public init() {}
    
    let roundRock = "O"
    let cubeRock = "#"
    let ground = "."
    
    public func part1(_ input: [String]) -> Int {
        var grid = Grid<String>(input)
        tilt(.up, grid: &grid)
        return calculateLoad(.up, grid: grid)
    }
    
    public func part2(_ input: [String], iterations: Int) -> Int {
        var grid = Grid<String>(input)
        var cache = [[String]]()
        var currentIndex = 0
        var pivotIndex = 0
        for i in (0..<iterations) {
            tilt(.up, grid: &grid)
            tilt(.left, grid: &grid)
            tilt(.down, grid: &grid)
            tilt(.right, grid: &grid)
            if let cacheIndex = cache.firstIndex(of: grid.items) {
                pivotIndex = cacheIndex
                currentIndex = i
                break
            }
            cache.append(grid.items)
        }

        let remainder = (iterations - currentIndex) % (cache.count - pivotIndex)
        let finalGrid = Grid<String>(columns: grid.columns, items: cache[pivotIndex + remainder - 1])
        return calculateLoad(.up, grid: finalGrid)
    }
}

extension Day14 {
    func calculateLoad(_ direction: Direction, grid: Grid<String>) -> Int {
        var sum = 0
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                switch direction {
                    case .up:
                        if grid[x,y] == roundRock {
                            sum += grid.rows - y
                        }
                        
                    case .down:
                        if grid[x,y] == roundRock {
                            sum += y + 1
                        }
                        
                    case .left:
                        if grid[x,y] == roundRock {
                            sum += grid.columns - x
                        }
                        
                    case .right:
                        if grid[x,y] == roundRock {
                            sum += x + 1
                        }
                }
            }
        }
        return sum
    }
    
    func tilt(_ direction: Direction, grid: inout Grid<String>) {
        for i in (0..<grid.items.count) {
            var point: Point
            if [.down, .right].contains(direction) {
                point = grid.point(for: grid.items.count - i - 1)
            } else {
                point = grid.point(for: i)
            }
            if grid[point] == roundRock {
                while true {
                    let next = point + direction.point
                    if next.isValid(max: grid.bottomRight) && grid[next] == ground {
                        grid[next] = roundRock
                        grid[point] = ground
                        point = next
                        continue
                    }
                    break
                }
            }
        }
    }
}
