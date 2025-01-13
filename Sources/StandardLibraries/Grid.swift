import Foundation

public struct MazeRunner: Hashable {
    public var point: Point
    public var direction: Direction
    public init(point: Point, direction: Direction) {
        self.point = point
        self.direction = direction
    }
}

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
    
    public func index(for point: Point) -> Int {
        point.x + point.y * columns
    }
        
    public func points(for value: T) -> [Point] {
        var points = [Point]()
        
        for i in (0..<items.count) {
            if items[i] == value {
                points.append(point(for: i))
            }
        }
        
        return points
    }
    
    public var points: [Point: T] {
        var points = [Point: T]()
        
        for x in 0..<columns {
            for y in 0..<rows {
                points[Point(x, y)] = self[x, y]
            }
        }
        
        return points
    }
    
    public func row(at y: Int) -> [T] {
        var values = [T]()
        for x in 0..<columns {
            values.append(self[x,y])
        }
        return values
    }
    
    public func column(at x: Int) -> [T] {
        var values = [T]()
        for y in 0..<rows {
            values.append(self[x,y])
        }
        return values
    }
}

extension Grid where T == String {
    public func point(for value: String) -> Point? {
        guard let index = items.firstIndex(of: value) else { return nil }
        return point(for: index)
    }
}

extension Grid where T == [String] {
    public init(_ input: [String]) {
        var items = [[String]]()
        
        for line in input {
            line.forEach { items.append([String($0)]) }
        }
        
        self.columns = input[0].count
        self.items = items
    }
}

extension Grid where T == String {
    public init(_ input: [String]) {
        var items = [String]()
        
        for line in input {
            line.forEach { items.append(String($0)) }
        }
        
        self.columns = input[0].count
        self.items = items
    }
    
    public init(_ input: [String], size: Point) {
        var items = [String]()
        
        for line in input {
            for i in 0..<size.x {
                if i < line.count {
                    items.append(String(line[i]))
                } else {
                    items.append(" ")
                }
            }
        }
        
        self.columns = size.x
        self.items = items
    }
}

extension Grid where T == String {
    public init(size: Point, fill: String) {
        self.columns = size.x
        self.items = Array(repeating: fill, count: size.x * size.y)
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
}

extension Grid where T == String {
    public func routeTo(start: Point, end: Point, emptyBlocks: [String]) -> [Point] {
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point: Point]()
        var costSoFar = [Point: Int]()
        costSoFar[start] = 0
        
        // calculate shortest path
        while !queue.isEmpty {
            // Using a priority queue means we always pick the next cheapest value
            let current = queue.dequeue()!
            if current == end {
                break   // exit early
            }
            
            for next in current.cardinalNeighbors(max: bottomRight) {
                guard emptyBlocks.contains(self[next]) else { continue }
                let newCost = costSoFar[current, default: 0] + 1
                if newCost < costSoFar[next, default: Int.max] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost)
                    cameFrom[next] = current
                }
            }
        }
        
        var path = [end]
        var next = end
        while let check = cameFrom[next] {
            next = check
            path.append(next)
        }
        path = path.dropLast()
        return path.reversed()
    }
    
    public func dijkstra(start: Point, end: Point, calculateScore: (Point) -> Int, canEnter: (Point) -> Bool) -> Int {
        dijkstra(start: start, end: end, maxPoint: bottomRight, calculateScore: calculateScore, canEnter: canEnter)
    }
    
    // https://www.redblobgames.com/pathfinding/a-star/introduction.html
    public func dijkstra(start: Point, end: Point, maxPoint: Point, shouldDrawPath: Bool = false, calculateScore: (Point) -> Int, canEnter: (Point) -> Bool) -> Int {
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point: Point]()
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
                guard canEnter(next) else { continue }
                let newCost = costSoFar[current, default: 0] + calculateScore(next)
                if newCost < costSoFar[next, default: Int.max] {
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
    
    public func dijkstra(start: Point, end: Point, shouldDrawPath: Bool = false, calculateScore: (Point) -> Int, canEnter: (Point) -> Bool, nextOptions: (Point, Point) -> [Point]) -> Int {
        let queue = PriorityQueue<Point>()
        queue.enqueue(start, priority: 0)
        var cameFrom = [Point: Point]()
        var costSoFar = [Point: Int]()
        costSoFar[start] = 0
        
        // calculate shortest path
        while !queue.isEmpty {
            // Using a priority queue means we always pick the next cheapest value
            let current = queue.dequeue()!
            if current == end {
                break   // exit early
            }
            
            for next in nextOptions(cameFrom[current, default: .zero], current) {
                guard canEnter(next) else { continue }
                let newCost = costSoFar[current, default: 0] + calculateScore(next)
                if newCost < costSoFar[next, default: Int.max] {
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
    
    struct DijkstraCacheItem<E: Hashable>: Hashable {
        let previous: E
        let value: E
        let costSoFar: Int
        let history: [E]
    }
    
    public func dijkstra(
        start: Vector,
        end: Vector,
        calculateScore: (Vector, Vector) -> Int,
        canEnter: (Vector) -> Bool,
        nextOptions: (Vector, Vector) -> [Vector]
    ) -> Int {
        let queue = PriorityQueue<DijkstraCacheItem<Vector>>()
        queue.enqueue(DijkstraCacheItem(previous: start, value: start, costSoFar: 0, history: [start]), priority: 0)
        var cameFrom = [Vector: Vector]()
        var finalCost = Int.max
        
        // calculate shortest path
        while !queue.isEmpty {
            // Using a priority queue means we always pick the next cheapest value
            let current = queue.dequeue()!
            if current.value == end {
                finalCost = min(finalCost, current.costSoFar)
                break
            }
            
            guard finalCost == Int.max || current.costSoFar < finalCost else { continue }
            let from = current.previous
            for next in nextOptions(from, current.value) {
                guard canEnter(next) else { continue }
                let cost = calculateScore(current.value, next)
                let newCost = current.costSoFar + cost
                queue.enqueue(DijkstraCacheItem(previous: current.value, value: next, costSoFar: newCost, history: current.history + [next]), priority: newCost)
                cameFrom[next] = current.value
            }
        }
        
        return finalCost-1
    }
    
    public func dijkstraPath(start: Point, end: Point, calculateScore: (Point) -> Int, canEnter: (Point) -> Bool) -> ([Point], [Point: Int]) {
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
            
            for next in current.cardinalNeighbors(max: bottomRight) {
                guard canEnter(next) else { continue }
                let newCost = costSoFar[current, default: 0] + calculateScore(next)
                if newCost < costSoFar[next, default: Int.max] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost)
                    cameFrom[next] = current
                }
            }
        }
        
        var path = [Point]()
        var current: Point? = end
        while current != nil {
            path.append(current!)
            current = cameFrom[current!]
        }
        
        return (path.reversed(), costSoFar)
    }
    
    public func dijkstra(start: Point, end: Point, maxPoint: Point, shouldDrawPath: Bool = false, calculateScore: (Point?, Point, Point) -> Int) -> Int {
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
                let newCost = costSoFar[current, default: 0] + calculateScore(cameFrom[current], current, next)
                if newCost < costSoFar[next, default: Int.max] {
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
    
    func drawCalculatedPath(_ end: Point, _ cameFrom: inout [Point : Point]) {
//        var path = [Point]()
//        var current: Point? = end
//        while current != nil {
//            if let point = current, let next = cameFrom[point] {
//                path.append(next)
//                current = next
//            } else {
//                current = nil
//            }
//        }
//        
//        path.reversed().forEach { print($0) }
        
        var grid = self
        var current: Point? = end
        while current != nil {
            grid[current!] = "O"
            current = cameFrom[current!]
        }
        grid.draw()
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
                if newCost < costSoFar[next, default: Int.max] {
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
                if newCost < costSoFar[next, default: Int.max] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost + current.manhattanDistance(to: next))
                    cameFrom[next] = current
                }
            }
        }
        
        return costSoFar[end, default: -1]
    }
    
    public func aStar(start: Point, end: Point, maxPoint: Point, calculateScore: (Point?, Point, Point) -> Int) -> Int {
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
                let newCost = costSoFar[current, default: 0] + calculateScore(cameFrom[current], current, next)
                if newCost < costSoFar[next, default: Int.max] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost + current.manhattanDistance(to: next))
                    cameFrom[next] = current
                }
            }
        }
        
        return costSoFar[end, default: -1]
    }
}

extension Grid where T == Int {
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
                if newCost < costSoFar[next, default: Int.max] {
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
    
    public func dijkstra(start: Point, end: Point, maxPoint: Point, shouldDrawPath: Bool = false, calculateScore: (Point?, Point, Point) -> Int) -> Int {
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
                let newCost = costSoFar[current, default: 0] + calculateScore(cameFrom[current], current, next)
                if newCost < costSoFar[next, default: Int.max] {
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
    
    func drawCalculatedPath(_ end: Point, _ cameFrom: inout [Point : Point]) {
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
                if newCost < costSoFar[next, default: Int.max] {
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
                if newCost < costSoFar[next, default: Int.max] {
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
    
    public func draw(with points: [Point], value: String) {
        for y in (0..<items.count/columns) {
            var row = ""
            for x in (0..<columns) {
                if points.contains(Point(x, y)) {
                    row += value
                } else {
                    row += "\(self[x,y])"
                }
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
