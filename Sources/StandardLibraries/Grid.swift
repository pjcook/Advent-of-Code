import Foundation

public struct Grid<T: Hashable>: Hashable {
    public var rows: Int {
        items.count / columns
    }
    public let columns: Int
    public var items: [T]
    public var bottomRight: Point {
        Point(columns, rows)
    }
    
    public init(columns: Int, items: [T]) {
        self.columns = columns
        self.items = items
    }
    
    public subscript(x: Int, y: Int) -> T {
        get {
            let index = x + y * columns
            return items[index]
        }
        set {
            let index = x + y * columns
            items[index] = newValue
        }
    }
    
    public subscript(point: Point) -> T {
        get {
            self[point.x, point.y]
        }
        set {
            self[point.x, point.y] = newValue
        }
    }
    
    public func point(for index: Int) -> Point {
        Point(index % columns, index / columns)
    }
}

extension Grid where T == Int {
    public init(_ input: [String]) {
        var items = [Int]()
        
        for line in input {
            line.forEach { items.append(Int(String($0))!) }
        }
        
        self.columns = input[0].count
        self.items = items
    }
    
    public func dijkstra(start: Point, end: Point, calculateScore: (Point) -> Int) -> Int {
        dijkstra(start: start, end: end, maxPoint: bottomRight, calculateScore: calculateScore)
    }
    
    // https://www.redblobgames.com/pathfinding/a-star/introduction.html
    public func dijkstra(start: Point, end: Point, maxPoint: Point, shouldDrawPath: Bool = false, calculateScore: (Point) -> Int) -> Int {
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point:Point]()
        var costSoFar = [Point: Int]()
        costSoFar[start] = 0
        
        // calculate shortest path
        while !queue.isEmpty {
            // Using a priority queue means we always pick the next cheapest value
            let current = queue.dequeue()!
            if current == end {
                break   // exit early
            }
            
            for next in current.cardinalNeighbors(max: maxPoint) {
                let newCost = costSoFar[current, default: 0] + calculateScore(next)
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost)
                    cameFrom[next] = current
                }
            }
        }
        
        // Draw Path
        if shouldDrawPath {
            drawCalculatedPath(end, &cameFrom)
        }
        
        return costSoFar[end, default: -1]
    }
    
    public func dijkstra(start: Point, end: Point, maxPoint: Point, shouldDrawPath: Bool = false, calculateScore: (Point, Point) -> Int) -> Int {
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point:Point]()
        var costSoFar = [Point: Int]()
        costSoFar[start] = 0
        
        // calculate shortest path
        while !queue.isEmpty {
            // Using a priority queue means we always pick the next cheapest value
            let current = queue.dequeue()!
            if current == end {
                break   // exit early
            }
            
            for next in current.cardinalNeighbors(max: maxPoint) {
                let newCost = costSoFar[current, default: 0] + calculateScore(current, next)
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost)
                    cameFrom[next] = current
                }
            }
        }
        
        // Draw Path
        if shouldDrawPath {
            drawCalculatedPath(end, &cameFrom)
        }
        
        return costSoFar[end, default: -1]
    }
    
    fileprivate func drawCalculatedPath(_ end: Point, _ cameFrom: inout [Point : Point]) {
        var path = [Point]()
        var current: Point? = end
        while current != nil {
            if let point = current, let next = cameFrom[point] {
                path.append(next)
                current = next
            } else {
                current = nil
            }
        }
        
        path.reversed().forEach { print($0) }
    }
    
    public func aStar(start: Point, end: Point, calculateScore: (Point) -> Int) -> Int {
        aStar(start: start, end: end, maxPoint: bottomRight, calculateScore: calculateScore)
    }
    
    public func aStar(start: Point, end: Point, maxPoint: Point, calculateScore: (Point) -> Int) -> Int {
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point:Point]()
        var costSoFar = [Point: Int]()
        costSoFar[start] = 0
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            if current == end {
                break
            }
            
            for next in current.cardinalNeighbors(max: maxPoint) {
                let newCost = costSoFar[current, default: 0] + calculateScore(next)
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost + current.manhattanDistance(to: next))
                    cameFrom[next] = current
                }
            }
        }
        
        return costSoFar[end, default: -1]
    }
    
    public func aStar(start: Point, end: Point, maxPoint: Point, calculateScore: (Point, Point) -> Int) -> Int {
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point:Point]()
        var costSoFar = [Point: Int]()
        costSoFar[start] = 0
        
        while !queue.isEmpty {
            let current = queue.dequeue()!
            if current == end {
                break
            }
            
            for next in current.cardinalNeighbors(max: maxPoint) {
                let newCost = costSoFar[current, default: 0] + calculateScore(current, next)
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost + current.manhattanDistance(to: next))
                    cameFrom[next] = current
                }
            }
        }
        
        return costSoFar[end, default: -1]
    }
}

extension Grid: Equatable {
    public static func == (lhs: Grid<T>, rhs: Grid<T>) -> Bool {
        lhs.columns == rhs.columns && lhs.columns == rhs.columns
    }
}

extension Grid {
    public func draw() {
        for y in (0..<items.count/columns) {
            var row = ""
            for x in (0..<columns) {
                row += "\(self[x,y])"
            }
            print(row)
        }
    }
    
    public func drawUpsidedown() {
        for i in (1...rows) {
            let y = rows - i
            var row = ""
            for x in (0..<columns) {
                row += "\(self[x,y])"
            }
            print(row)
        }
    }
    
    public func drawForBool(on: String = "#", off: String = ".") {
        guard let grid = self as? Grid<Bool> else { return }
        for y in (0..<items.count/columns) {
            var row = ""
            for x in (0..<columns) {
                row += "\(grid[x,y] ? on : off)"
            }
            print(row)
        }
        print()
    }
}
