import Foundation
import StandardLibraries

public struct Day17 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid<Int>(input)
        return calculatePath2(start: .zero, end: Point(grid.columns - 1, grid.rows - 1), grid: grid, part2: false)
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = Grid<Int>(input)
        return calculatePath2(start: .zero, end: Point(grid.columns - 1, grid.rows - 1), grid: grid, part2: true)
    }
    
    struct Entry: Hashable {
        let dist: Int
        let point: Point
        let dir: Int
        let indir: Int
        
        var value: Int { dist }
    }
    
    struct History: Hashable {
        let point: Point
        let dir: Int
        let indir: Int
        
        init(point: Point, dir: Int, indir: Int) {
            self.point = point
            self.dir = dir
            self.indir = indir
        }
        
        init(_ entry: Entry) {
            self.point = entry.point
            self.dir = entry.dir
            self.indir = entry.indir
        }
    }
}

extension Day17 {
    func calculatePath2(start: Point, end: Point, grid: Grid<Int>, part2: Bool) -> Int {
        let queue = PriorityQueue<Entry>()
        queue.enqueue(Entry(dist: 0, point: .zero, dir: -1, indir: -1), priority: 0)
        var processed = [History: Int]()
        var step = 0
        var lowest = Int.max
        
        while let item = queue.dequeue() {
            if item.point == end {
                lowest = min(lowest, item.dist)
                print(step, item.dist)
                break
            }
            
            let history = History(item)
            if processed[history] != nil {
                assert(item.dist >= processed[history]!)
                continue
            }
            
            processed[history] = item.dist
            for direction in Direction.allCases {
                let point = item.point + direction.point
                let new_dir = direction.rawValue
                let new_indir = new_dir != item.dir ? 1 : item.indir + 1
                guard ((new_dir + 2) % 4 != item.dir), point.isValid(max: grid.bottomRight) else { continue }
                let isValid_part1 = new_indir <= 3
                let isValid_part2 = new_indir <= 10 && (new_dir == item.dir || item.indir >= 4 || item.indir == -1)

                guard part2 ? isValid_part2 : isValid_part1 else { continue }                
                let cost = grid[point]
                let nextCost = item.dist + cost
                queue.enqueue(Entry(dist: nextCost, point: point, dir: new_dir, indir: new_indir), priority: nextCost)
            }
            
            step += 1
        }
        
        return lowest
    }
}
