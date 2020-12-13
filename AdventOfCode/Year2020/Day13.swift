import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let timestamp = Int(input[0])!

        return
            input[1].components(separatedBy: ",")
            .compactMap { Int(String($0)) }
            .map { ($0 - (timestamp % $0), $0) }
            .sorted(by: { a, b in a.0 < b.0 })
            .first
            .map { $0.0 * $0.1 }!
    }
    
    public struct Bus {
        public let id: Int
        public let startAddition: Int
        public init?(input: (offset: Int, element: String)) {
            guard let num = Int(input.1) else { return nil }
            self.id = num
            self.startAddition = input.0
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        let input = input[1].components(separatedBy: ",")
        let busses = input.enumerated().compactMap(Bus.init)

        var runningTime = busses.first!.id
        var strideByValue = 1
        for bus in busses {
            let strides = stride(from: runningTime, to: .max, by: strideByValue)
            runningTime = strides
                .first(where: { time in
                    return (time + bus.startAddition).isMultiple(of: bus.id)
                })!
            strideByValue *= bus.id
        }

        return runningTime
    }
}
