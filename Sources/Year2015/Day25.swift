import Foundation
import StandardLibraries

public struct Day25 {
    public init() {}
    
    public func part1(_ input: Point) -> Int {
        let index = convert(point: input)
        return (1..<index).reduce(20151125) { p, _ in
            calculate(value: p)
        }
    }
    
    public func convert(point: Point) -> Int {
        (0..<point.y-1).reduce((1...point.x).reduce(0, +)) { $0 + point.x + $1}
    }
    
    public func calculate(value: Int) -> Int {
        value * 252533 % 33554393
    }
}
