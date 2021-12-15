import Foundation

public struct Grid<T> {
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
    
    public func dijkstra(start: Point, end: Point) -> Int {
        dijkstra(start: start, end: end, maxPoint: bottomRight)
    }
    
    // https://www.redblobgames.com/pathfinding/a-star/introduction.html
    public func dijkstra(start: Point, end: Point, maxPoint: Point, shouldDrawPath: Bool = false) -> Int {
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
                let gridPoint = Point(next.x % columns, next.y % rows)
                var gridScore = self[gridPoint] + Int(next.x / columns) + Int(next.y / rows)
                if gridScore > 9 {
                    gridScore -= 9
                }
                let newCost = costSoFar[current, default: 0] + gridScore
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost)
                    cameFrom[next] = current
                }
            }
        }
        
        //        print(costSoFar.count, cameFrom.count)
        
        // Draw Path
        if shouldDrawPath {
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
        
        return costSoFar[end, default: -1]
    }
    
    public func aStar(start: Point, end: Point) -> Int {
        aStar(start: start, end: end, maxPoint: bottomRight)
    }
    
    public func aStar(start: Point, end: Point, maxPoint: Point) -> Int {
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
                let gridPoint = Point(next.x % columns, next.y % rows)
                var gridScore = self[gridPoint] + Int(next.x / columns) + Int(next.y / rows)
                if gridScore > 9 {
                    gridScore -= 9
                }
                let newCost = costSoFar[current, default: 0] + gridScore
                if costSoFar[next] == nil || newCost < costSoFar[next, default: 0] {
                    costSoFar[next] = newCost
                    queue.enqueue(next, priority: newCost + current.distance(to: next))
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
