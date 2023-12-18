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
    
    public func part1b(_ input: [String]) -> Int {
        let grid = Grid<Int>(input)
        return calculatePath3(start: .zero, end: Point(grid.columns - 1, grid.rows - 1), grid: grid, part2: false)
    }
    
    public func part2b(_ input: [String]) -> Int {
        let grid = Grid<Int>(input)
        return calculatePath3part2(start: .zero, end: Point(grid.columns - 1, grid.rows - 1), grid: grid)
    }
    
    struct Entry: Hashable {
        let heatLoss: Int
        let row: Int
        let col: Int
        let dir: Int
        let indir: Int
        
        var value: Int { heatLoss }
    }
    
    struct History: Hashable {
        let row: Int
        let col: Int
        let dir: Int
        let indir: Int
        
        init(_ entry: Entry) {
            self.row = entry.row
            self.col = entry.col
            self.dir = entry.dir
            self.indir = entry.indir
        }
        
        static func == (lhs: History, rhs: History) -> Bool {
            lhs.row == rhs.row && lhs.col == rhs.col && lhs.dir == rhs.dir && lhs.indir == rhs.indir
        }
    }
}

extension Day17 {
    func calculatePath2(start: Point, end: Point, grid: Grid<Int>, part2: Bool) -> Int {
        let queue = PriorityQueue<Entry>()
        queue.enqueue(Entry(heatLoss: 0, row: 0, col: 0, dir: -1, indir: -1), priority: 0)
        var processed = [History: Int]()
        var step = 0
        var lowest = Int.max
        
        while let item = queue.dequeue() {
            if item.row == end.y && item.col == end.x {
                lowest = min(lowest, item.heatLoss)
//                print(step, item.dist)
                break
            }
            
            let history = History(item)
            if processed[history] != nil {
//                assert(item.dist >= processed[history]!)
                continue
            }
            
            processed[history] = item.heatLoss
            for (direction, (dr, dc)) in [(-1,0),(0,1),(1,0),(0,-1)].enumerated() {
                let rr = item.row + dr
                let cc = item.col + dc
                let new_dir = direction
                let new_indir = new_dir != item.dir ? 1 : item.indir + 1
                guard 
                    ((new_dir + 2) % 4 != item.dir),
                    rr >= 0, cc >= 0, rr < grid.rows, cc < grid.columns
                else { continue }
                
                let isValid_part1 = new_indir <= 3
                let isValid_part2 = new_indir <= 10 && (new_dir == item.dir || item.indir >= 4 || item.indir == -1)

                guard part2 ? isValid_part2 : isValid_part1 else { continue }                
                let cost = grid[cc,rr]
                let nextCost = item.heatLoss + cost
                queue.enqueue(Entry(heatLoss: nextCost, row: rr, col: cc, dir: new_dir, indir: new_indir), priority: nextCost)
            }
            
            step += 1
        }
        
        return lowest
    }
    
    func calculatePath3(start: Point, end: Point, grid: Grid<Int>, part2: Bool) -> Int {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        let queue = PriorityQueue<Entry>()
        queue.enqueue(Entry(heatLoss: 0, row: 0, col: 0, dir: -1, indir: 0), priority: 0)
        var seen = Set<History>()
        while let item = queue.dequeue() {            
            if item.row == end.y && item.col == end.x && (part2 ? item.indir >= 4 : true) {
                return item.heatLoss
            }
            
            let history = History(item)
            guard seen.contains(history) == false else  { continue }
            seen.insert(history)
            
            if item.indir < (part2 ? 10 : 3) && item.dir != -1 {
                let direction = directions[item.dir]
                let nr = item.row + direction.0
                let nc = item.col + direction.1
                if nr >= 0 && nc >= 0 && nr < grid.rows && nc < grid.columns {
                    let hl = item.heatLoss + grid[nc,nr]
                    queue.enqueue(Entry(heatLoss: hl, row: nr, col: nc, dir: item.dir, indir: item.indir + 1), priority: hl)
                }
            }
            
            if (part2 ? item.indir >= 4 : true) || item.dir == -1 {
                for (i, direction) in directions.enumerated() {
                    if i != item.dir && (i + 2) % 4 != item.dir {
                        let nr = item.row + direction.0
                        let nc = item.col + direction.1
                        if nr >= 0 && nc >= 0 && nr < grid.rows && nc < grid.columns {
                            let hl = item.heatLoss + grid[nc,nr]
                            queue.enqueue(Entry(heatLoss: hl, row: nr, col: nc, dir: i, indir: 1), priority: hl)
                        }
                    }
                }
            }
        }
        
        return -1
    }
    
    func calculatePath3part2(start: Point, end: Point, grid: Grid<Int>) -> Int {
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        let queue = PriorityQueue<Entry>()
        queue.enqueue(Entry(heatLoss: 0, row: 0, col: 0, dir: -1, indir: 0), priority: 0)
        var seen = Set<History>()
        while let item = queue.dequeue() {            
            if item.row == end.y && item.col == end.x && item.indir >= 4 {
                return item.heatLoss
            }
            
            let history = History(item)
            guard seen.contains(history) == false else  { continue }
            seen.insert(history)
            
            if item.indir < 10 && item.dir != -1 {
                let direction = directions[item.dir]
                let nr = item.row + direction.0
                let nc = item.col + direction.1
                if nr >= 0 && nc >= 0 && nr < grid.rows && nc < grid.columns {
                    let hl = item.heatLoss + grid[nc,nr]
                    queue.enqueue(Entry(heatLoss: hl, row: nr, col: nc, dir: item.dir, indir: item.indir + 1), priority: hl)
                }
            }
            
            if item.indir >= 4 || item.dir == -1 {
                for (i, direction) in directions.enumerated() {
                    if i != item.dir && (i + 2) % 4 != item.dir {
                        let nr = item.row + direction.0
                        let nc = item.col + direction.1
                        if nr >= 0 && nc >= 0 && nr < grid.rows && nc < grid.columns {
                            let hl = item.heatLoss + grid[nc,nr]
                            queue.enqueue(Entry(heatLoss: hl, row: nr, col: nc, dir: i, indir: 1), priority: hl)
                        }
                    }
                }
            }
        }
        
        return -1
    }
}
