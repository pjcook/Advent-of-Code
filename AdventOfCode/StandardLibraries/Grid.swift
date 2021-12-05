import Foundation

public struct Grid<T> {
    public let columns: Int
    public var items: [T]
    
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
}
