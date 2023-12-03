import Foundation
import StandardLibraries

public struct Day3 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let grid = parse(input)
        var result = 0
        let symbols = ["%", "/", "$", "+", "@", "=", "&", "#", "*", "-"]
//        var symbols = extractSetOfNonNumericCharacters(grid: grid)
//        symbols.remove(".")
        
        // Look for symbols
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let value = grid[x,y]
                guard symbols.contains(value) else { continue }
                let sum = extractAdjacentNumbers(grid: grid, point: Point(x, y))
                    .reduce(0, +)
                result += sum
            }
        }
        
        return result
    }
    
    public func part2(_ input: [String]) -> Int {
        let grid = parse(input)
        var result = 0
        let symbols = ["*"]
        
        // Look for symbols
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let value = grid[x,y]
                guard symbols.contains(value) else { continue }
                let numbers = extractAdjacentNumbers(grid: grid, point: Point(x, y))
                guard numbers.count == 2 else { continue }
                result += numbers.reduce(1, *)
            }
        }
        
        return result
    }
}

extension Day3 {
    func extractAdjacentNumbers(grid: Grid<String>, point: Point) -> [Int] {
        let maxPoint = grid.bottomRight
        var results = [Int]()
        var neighbors = Set(point.neighbors(false, min: .zero, max: maxPoint))
        
        while let neighbor = neighbors.popFirst() {
            let value = grid[neighbor]
            let characterSet = CharacterSet(charactersIn: value)
            guard characterSet.isSubset(of: .decimalDigits) else { continue }
            
            var digits = value
            // Found a number
            
            // scanLeft
            var lastPoint = neighbor
            while true {
                lastPoint = lastPoint.left()
                guard lastPoint.isValid(max: maxPoint) else { break }
                let value = grid[lastPoint]
                let characterSet = CharacterSet(charactersIn: value)
                guard characterSet.isSubset(of: .decimalDigits) else { break }
                neighbors.remove(lastPoint)
                digits = value + digits
            }
            
            // scanRight
            lastPoint = neighbor
            while true {
                lastPoint = lastPoint.right()
                guard lastPoint.isValid(max: maxPoint) else { break }
                let value = grid[lastPoint]
                let characterSet = CharacterSet(charactersIn: value)
                guard characterSet.isSubset(of: .decimalDigits) else { break }
                neighbors.remove(lastPoint)
                digits = digits + value
            }
            
            let number = Int(digits)!
            results.append(number)
        }
        
        return results
    }
    
    func extractSetOfNonNumericCharacters(grid: Grid<String>) -> Set<String> {
        // Example gives: ["#", "$", "*", ".", "+"]
        // Puzzle input gives: ["%", "/", "$", "+", ".", "@", "=", "&", "#", "*", "-"]
        var nonDigitCharacters = Set<String>()
        for y in (0..<grid.rows) {
            for x in (0..<grid.columns) {
                let value = grid[x,y]
                let characterSet = CharacterSet(charactersIn: value)
                if !characterSet.isSubset(of: .decimalDigits) {
                    nonDigitCharacters.insert(value)
                }
            }
        }
        return nonDigitCharacters
    }
    
    func parse(_ input: [String]) -> Grid<String> {
        Grid(input)
    }
}
