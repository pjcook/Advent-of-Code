import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public struct Traversal {
        public init(right: Int, down: Int) {
            self.right = right
            self.down = down
        }
        
        let right: Int
        let down: Int
    }
    
    public func howManyTrees(input: [String], traversal: Traversal) -> Int {
        var point = Point.zero
        var treesHit = 0
        let maxX = input[0].count
        let maxY = input.count
        
        while point.y < maxY-1 {
            point.increment(traversal)
            point.bound(to: maxX)
            if point.y < maxY, input[point.y][point.x] == "#" {
                treesHit += 1
            }
        }
        
        return treesHit
    }
}

extension Point {
    mutating func increment(_ traversal: Day3.Traversal) {
        x += traversal.right
        y += traversal.down
    }
    
    mutating func bound(to maxX: Int) {
        if x >= maxX {
            x -= maxX
        }
    }
}
