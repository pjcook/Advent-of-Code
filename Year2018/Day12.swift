import Foundation

public struct Day12 {
    public init() {}
    
    public func solve(_ input: [String], iterations: Int) -> Int {
        let plants = Plants(input)
//        print(plants.pots.keys.sorted().map { plants.pots[$0]! }.joined())
        // print out the output in the iterate generation function until the pattern stops being different, for my input it's after 90 iterations
        let n = 90
        for i in (1...min(n, iterations)) {
            plants.iterateGeneration(i)
        }
        var additive = 0
        if iterations > n {
            additive = iterations - min(n, iterations)
        }
//        print(plants.pots.count, plants.minPot, plants.maxPot)
        return plants.pots.reduce(0) {
            $0 + ($1.value == "#" ? $1.key + additive : 0)
        }
    }

    public class Plants {
        public typealias Pattern = String
        public var pots = [Int:String]()
        public let rules: Set<Pattern>
        public var minPot: Int
        public var maxPot: Int

        public init(_ input: [String]) {
            let initialState = input[0].replacingOccurrences(of: "initial state: ", with: "")
            for i in (0..<initialState.count) {
                pots[i] = String(initialState[i])
            }
            maxPot = initialState.count
            minPot = -2

            var rules = Set<Pattern>()
            for i in (2..<input.count) {
                let line = input[i]
                let pattern = String(line[0..<5])
                let result = line[9]
                if result == "#" {
                    rules.insert(pattern)
                }
            }

            self.rules = rules
        }

        func patternAt(_ index: Int) -> Pattern {
            var pattern = ""
            pattern += pots[index-2, default: "."]
            pattern += pots[index-1, default: "."]
            pattern += pots[index, default: "."]
            pattern += pots[index+1, default: "."]
            pattern += pots[index+2, default: "."]
            return pattern
        }

        public func iterateGeneration(_ generation: Int) {
            var output = pots
            for i in minPot..<maxPot {
                if pots[i] == "#" {
                    minPot = i - 3
                    break
                }
            }
            if pots[maxPot] == "#" || pots[maxPot - 1] == "#" {
                maxPot += 3
            }
            for i in (minPot...maxPot) {
                output[i] = rules.contains(patternAt(i)) ? "#" : "."
            }
//            print(generation, minPot, output.keys.sorted().map { output[$0]! }.joined())
            pots = output
        }
    }
}
