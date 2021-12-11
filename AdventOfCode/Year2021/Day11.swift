import Foundation
import StandardLibraries

public struct Day11 {
    public init() {}
    
    /*
     There are 100 octopuses arranged neatly in a 10 by 10 grid. Each octopus slowly gains energy over time and flashes brightly for a moment when its energy is full.
     
     The energy level of each octopus is a value between 0 and 9.
     
     You can model the energy levels and flashes of light in steps. During a single step, the following occurs:

     • First, the energy level of each octopus increases by 1.
     • Then, any octopus with an energy level greater than 9 flashes. This increases the energy level of all adjacent octopuses by 1, including octopuses that are diagonally adjacent. If this causes an octopus to have an energy level greater than 9, it also flashes. This process continues as long as new octopuses keep having their energy level increased beyond 9. (An octopus can only flash at most once per step.)
     • Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
     
     Given the starting energy levels of the dumbo octopuses in your cavern, simulate 100 steps. How many total flashes are there after 100 steps?
     */
    public func part1(_ input: [String], steps: Int = 100) -> Int {
        // Initialise Grid
        var grid = Grid<Int>(input)
        // Storage to count the number of flashes
        var count = 0
        // The max grid position used to calculate neighbours
        let max = Point(grid.columns, grid.rows)

        // Iterate the required number of steps
        for _ in (0..<steps) {
            step(grid: &grid, count: &count, max: max)
        }
        
        return count
    }
    
    /*
     It seems like the individual flashes aren't bright enough to navigate. However, you might have a better option: the flashes seem to be synchronizing!
     
     If you can calculate the exact moments when the octopuses will all flash simultaneously, you should be able to navigate through the cavern. What is the first step during which all octopuses flash?
     
     Calculate when every single value is 0 all at the same time.
     */
    public func part2(_ input: [String]) -> Int {
        // Initialise Grid
        var grid = Grid<Int>(input)
        // Count does nothing but allows the code from part 1 to be reused
        var count = 0
        // The max grid position used to calculate neighbours
        let max = Point(grid.columns, grid.rows)
        // Used to end the loop
        var allFlashed = false
        // Used to count the number of steps
        var step = 0
        
        // Find the first synchronised step
        while !allFlashed {
            self.step(grid: &grid, count: &count, max: max)
            step += 1
            // Check if all values in the grid are 0
            allFlashed = grid.items.reduce(0, +) == 0
        }
        
        return step
    }
    
    /*
     Perform a single step
     • First, the energy level of each octopus increases by 1.
     • Then, any octopus with an energy level greater than 9 flashes. This increases the energy level of all adjacent octopuses by 1, including octopuses that are diagonally adjacent. If this causes an octopus to have an energy level greater than 9, it also flashes. This process continues as long as new octopuses keep having their energy level increased beyond 9. (An octopus can only flash at most once per step.)
     • Finally, any octopus that flashed during this step has its energy level set to 0, as it used all of its energy to flash.
     */
    public func step(grid: inout Grid<Int>, count: inout Int, max: Point) {
        // Storage for the positions that you would like to perform a flash on after incrementing the whole grid
        var requiresFlash = [Point]()
        
        // Increment the whole grid first, so that you can ignore positions with value 0 when flashing neighbours using recursion
        for i in (0..<grid.items.count) {
            // Current point
            let point = Point(i / grid.columns, i % grid.columns)
            // Current value
            let value = grid[point]
            if value == 9 {
                // If 9 then will need to flash neighbours, also reset to 0 so it's ignored during recursion
                requiresFlash.append(point)
                grid[point] = 0
            } else {
                // increment all other values by 1
                grid[point] = value + 1
            }
        }
        
        // Perform recursion on points that have flashed
        for point in requiresFlash {
            flash(point, grid: &grid, count: &count, max: max)
        }
    }
    
    public func flash(_ point: Point, grid: inout Grid<Int>, count: inout Int, max: Point) {
        // count the flash
        count += 1
        // set the grid point to zero
        grid[point] = 0
        // fetch the neighbouring points so they can be incremented
        let neighbours = point.neighbors(false, max: max)
        
        // check each neighbour
        for p in neighbours {
            let value = grid[p]
            if value == 0 {
                // If already 0 then ignore
                continue
            } else if value == 9 {
                // if already 9 then they need to flash, recurse
                flash(p, grid: &grid, count: &count, max: max)
            } else {
                // increment any other value
                grid[p] = value + 1
            }
        }
    }
}
