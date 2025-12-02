import Foundation
import Algorithms
import StandardLibraries

public struct Day2 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        parse(input)
            .map { findInvalidIds($0) }
            .reduce(0, +)
    }
    
    public func part2(_ input: String) -> Int {
        parse(input)
            .map { findInvalidIds2($0) }
            .reduce(0, +)
    }
}

extension Day2 {
    func findInvalidIds(_ range: Range<Int>) -> Int {
        var sum = 0

        for item in range {
            let value = String(item)
            guard value.count.isEven else { continue }
            let half = value.count / 2
            if value.substring(toIndex: half) == value.substring(fromIndex: half) {
                sum += item
            }
        }

        return sum
    }

    func findInvalidIds2(_ range: Range<Int>) -> Int {
        var sum = 0

        mainLoop: for item in range {
            let value = String(item)

            guard value.count > 1 else { continue }

            // All match
            if Array(repeating: String(value.first!), count: value.count).joined() == value {
                sum += item
                continue
            }

            guard value.count > 3 else { continue }

            // Chunked
            let half = value.count / 2
            outerLoop: for i in 2...half {
                guard value.count % i == 0 else { continue }
                
                let strides = value.chunked(size: i)
                let last = strides.first!
                for stride in strides[1...] {
                    guard last == stride else { continue outerLoop }
                }
                sum += item
                continue mainLoop
            }
        }

        return sum
    }

    func parse(_ input: String) -> [Range<Int>] {
        var ranges = [Range<Int>]()

        for part in input.split(separator: ",") {
            let parts = part.split(separator: "-").map(String.init).map(Int.init)
            ranges.append(Range<Int>(parts[0]!...parts[1]!))
        }

        return ranges
    }
}
