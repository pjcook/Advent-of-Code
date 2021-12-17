import Foundation
import StandardLibraries

public struct Day17 {
    public init() {}
    
    public struct TargetArea {
        public let topLeft: Point
        public let bottomRight: Point
        public let xRange: ClosedRange<Int>
        public let yRange: ClosedRange<Int>
        public init(topLeft: Point, bottomRight: Point) {
            self.topLeft = topLeft
            self.bottomRight = bottomRight
            xRange = (topLeft.x...bottomRight.x)
            yRange = (bottomRight.y...topLeft.y)
        }
    }
    
    public func part1(_ targetArea: TargetArea) -> Int {
        var maxY = 0
        
        for x in (1..<targetArea.topLeft.x + targetArea.bottomRight.x) {
            for y in (targetArea.bottomRight.y...abs(targetArea.bottomRight.y)) {
                if let y = calculateTrajectoryReturnMaxY(start: .zero, trajectory: Point(x,y), targetArea: targetArea) {
                    maxY = max(maxY, y)
                }
            }
        }
        
        return maxY
    }
    
    public func part2(_ targetArea: TargetArea) -> Int {
        var count = 0
        
        for x in (1..<targetArea.topLeft.x + targetArea.bottomRight.x) {
            for y in (targetArea.bottomRight.y...abs(targetArea.bottomRight.y)) {
                if calculateTrajectoryReturnMaxY(start: .zero, trajectory: Point(x,y), targetArea: targetArea) != nil {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    public func calculateTrajectoryReturnMaxY(start: Point, trajectory: Point, targetArea: TargetArea) -> Int? {
        var position = start
        var trajectory = trajectory
        var maxY: Int = 0
        var result: Int?
        while true {
            // move by trajectory
            position = position + trajectory
            
            maxY = max(maxY, position.y)
            
            // calculate if in targetArea
            if targetArea.xRange.contains(position.x) && targetArea.yRange.contains(position.y) {
                result = maxY
                break
            } else if position.y < targetArea.bottomRight.y {
                break
            }
            
            // affect trajectory by gravity and current
            if trajectory.x < 0 {
                trajectory = trajectory + Point(1,-1)
            } else if trajectory.x > 0 {
                trajectory = trajectory + Point(-1,-1)
            } else {
                trajectory = trajectory + Point(0,-1)
            }
        }
        
        return result
    }
}
