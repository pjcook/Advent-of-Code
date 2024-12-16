import Foundation
import StandardLibraries

public struct Day16 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = Grid<String>(input)
        let start = grid.point(for: grid.items.firstIndex(of: "S")!)
        let end = grid.point(for: grid.items.firstIndex(of: "E")!)
        
        return grid.dijkstra(start: start, end: end, maxPoint: grid.bottomRight, shouldDrawPath: true) { previous, current, next in
            if grid[next] == "#" {
                return 100000
            }
            
            let direction = previous != nil ? current.direction(from: previous!) : .right
            if next == current + direction.point {
                return 1
            } else {
                return 1001
            }
        }
    }
    
    public func part1b(_ input: [String]) -> Int {
        let directions = [Direction.up, Direction.right, Direction.down, Direction.left]
        let grid = Grid<String>(input)
        let start = grid.point(for: grid.items.firstIndex(of: "S")!)
        let end = grid.point(for: grid.items.firstIndex(of: "E")!)
        var best: Int?
        var seen = Set<SeenItem>()
        
        let queue = PriorityQueue<Item>()
        queue.enqueue(Item(point: start, directionIndex: 1, cost: 0), priority: 1)
        
        while let item = queue.dequeue() {
            if item.point == end && best == nil {
                best = item.cost
            }
            let seenItem = SeenItem(point: item.point, direction: directions[item.directionIndex])
            if seen.contains(seenItem) {
                continue
            }
            seen.insert(seenItem)
            let nextPoint = item.point + directions[item.directionIndex].point
            if nextPoint.isValid(max: grid.bottomRight), grid[nextPoint] != "#" {
                queue.enqueue(Item(point: nextPoint, directionIndex: item.directionIndex, cost: item.cost + 1), priority: item.cost + 1)
            }
            queue.enqueue(Item(point: item.point, directionIndex: (item.directionIndex + 1) % 4, cost: item.cost + 1000), priority: item.cost + 1000)
            queue.enqueue(Item(point: item.point, directionIndex: (item.directionIndex + 3) % 4, cost: item.cost + 1000), priority: item.cost + 1000)
        }
        
        return best!
    }
    
    public func part2b(_ input: [String]) -> Int {
        let directions = [Direction.up, Direction.right, Direction.down, Direction.left]
        let grid = Grid<String>(input)
        let start = grid.point(for: grid.items.firstIndex(of: "S")!)
        let end = grid.point(for: grid.items.firstIndex(of: "E")!)
        var best: Int?
        var seen = Set<SeenItem>()
        var dist = [SeenItem: Int]()
        var dist2 = [SeenItem: Int]()
        let queue = PriorityQueue<Item>()

        // Go forwards
        queue.enqueue(Item(point: start, directionIndex: 1, cost: 0), priority: 1)
        
        while let item = queue.dequeue() {
            let seenItem = SeenItem(point: item.point, direction: directions[item.directionIndex])
            if dist[seenItem] == nil {
                dist[seenItem] = item.cost
            }
            if item.point == end && best == nil {
                best = item.cost
            }
            if seen.contains(seenItem) {
                continue
            }
            seen.insert(seenItem)
            let nextPoint = item.point + directions[item.directionIndex].point
            if nextPoint.isValid(max: grid.bottomRight), grid[nextPoint] != "#" {
                queue.enqueue(Item(point: nextPoint, directionIndex: item.directionIndex, cost: item.cost + 1), priority: item.cost + 1)
            }
            queue.enqueue(Item(point: item.point, directionIndex: (item.directionIndex + 1) % 4, cost: item.cost + 1000), priority: item.cost + 1000)
            queue.enqueue(Item(point: item.point, directionIndex: (item.directionIndex + 3) % 4, cost: item.cost + 1000), priority: item.cost + 1000)
        }
        
        // Go backwards
        seen = Set<SeenItem>()
        queue.enqueue(Item(point: end, directionIndex: 0, cost: 0), priority: 0)
        queue.enqueue(Item(point: end, directionIndex: 1, cost: 0), priority: 0)
        queue.enqueue(Item(point: end, directionIndex: 2, cost: 0), priority: 0)
        queue.enqueue(Item(point: end, directionIndex: 3, cost: 0), priority: 0)
        
        while let item = queue.dequeue() {
            let seenItem = SeenItem(point: item.point, direction: directions[item.directionIndex])
            if dist2[seenItem] == nil {
                dist2[seenItem] = item.cost
            }
            if seen.contains(seenItem) {
                continue
            }
            seen.insert(seenItem)
            let nextPoint = item.point + directions[(item.directionIndex + 2) % 4].point
            if nextPoint.isValid(max: grid.bottomRight), grid[nextPoint] != "#" {
                queue.enqueue(Item(point: nextPoint, directionIndex: item.directionIndex, cost: item.cost + 1), priority: item.cost + 1)
            }
            queue.enqueue(Item(point: item.point, directionIndex: (item.directionIndex + 1) % 4, cost: item.cost + 1000), priority: item.cost + 1000)
            queue.enqueue(Item(point: item.point, directionIndex: (item.directionIndex + 3) % 4, cost: item.cost + 1000), priority: item.cost + 1000)
        }
        
        // find optimal path points
        var pathPoints = Set<Point>()
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                for dir in directions {
                    let item = SeenItem(point: Point(x, y), direction: dir)
                    if let d1 = dist[item], let d2 = dist2[item], d1 + d2 == best {
                        pathPoints.insert(item.point)
                    }
                }
            }
        }
        
        return pathPoints.count
    }
    
    struct SeenItem: Hashable {
        let point: Point
        let direction: Direction
    }
    
    struct Item: Hashable {
        let point: Point
        let directionIndex: Int
        let cost: Int
    }
}
