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
    
    /*
     So MAX X should be the last X position in your targetArea because with a single trajectory, you could jump to that X position i.e. you could jump directly into the target area. And the MIN Y should be the smallest Y value from your targetArea.
     X can never be 0 (unless your target area has a negative X range), or it won’t move and will never get into the target area.
     The maximum Y value on the other hand is a little more tricky, so I just made an assumption that the absolute value of the lowest Y position from the targetArea would likely do.
     */
    
    /*
     Find the initial velocity that causes the probe to reach the highest y position and still eventually be within the target area after any step. What is the highest y position it reaches on this trajectory?
     */
    public func part1(_ targetArea: TargetArea) -> Int {
        var maxY = 0
        
        for x in (1..<targetArea.topLeft.x) {
            for y in (0..<abs(targetArea.bottomRight.y)) {
                if shouldSkip(targetArea, x: x, y: y) { continue }
                if let y = calculateTrajectoryReturnMaxY(start: .zero, trajectory: Point(x,y), targetArea: targetArea) {
                    maxY = max(maxY, y)
                }
            }
        }
        
        return maxY
    }
    
    /*
     How many distinct initial velocity values cause the probe to be within the target area after any step?
     */
    public func part2(_ targetArea: TargetArea) -> Int {
        var count = 0

        for x in (1...targetArea.bottomRight.x) {
            for y in (targetArea.bottomRight.y..<abs(targetArea.bottomRight.y)) {
                if shouldSkip(targetArea, x: x, y: y) { continue }
                if calculateTrajectoryReturnMaxY(start: .zero, trajectory: Point(x,y), targetArea: targetArea) != nil {
                    count += 1
                }
            }
        }

        return count
    }
    
    // This is an optimisation to skip areas that definitely can never work
    public func shouldSkip(_ targetArea: TargetArea, x: Int, y: Int) -> Bool {
        return (x < targetArea.topLeft.x && y < targetArea.topLeft.y) || (x > targetArea.topLeft.x && y > targetArea.topLeft.y)
    }
    
    /*
     The probe launcher on your submarine can fire the probe with any integer velocity in the x (forward) and y (upward, or downward if negative) directions. For example, an initial x,y velocity like 0,10 would fire the probe straight up, while an initial velocity like 10,-1 would fire the probe forward at a slight downward angle.

     The probe's x,y position starts at 0,0. Then, it will follow some trajectory by moving in steps. On each step, these changes occur in the following order:

     The probe's x position increases by its x velocity.
     The probe's y position increases by its y velocity.
     Due to drag, the probe's x velocity changes by 1 toward the value 0; that is, it decreases by 1 if it is greater than 0, increases by 1 if it is less than 0, or does not change if it is already 0.
     Due to gravity, the probe's y velocity decreases by 1.
     */
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
            if position.y < targetArea.bottomRight.y {
                break
            } else if targetArea.xRange.contains(position.x) && targetArea.yRange.contains(position.y) {
                result = maxY
                break
            }
            
            // affect trajectory by gravity and current
            if trajectory.x > 0 {
                trajectory = trajectory + Point(-1,-1)
            } else if trajectory.x == 0 {
                trajectory = trajectory + Point(0,-1)
            } else {    // never going to happen
                trajectory = trajectory + Point(1,-1)
            }
        }
        
        return result
    }
}
