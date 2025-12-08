import Foundation
import StandardLibraries

public struct Day8 {
    public init() {}

    struct Pair: Hashable, Equatable {
        let v1: Vector
        let v2: Vector

        init( _ v1: Vector, _ v2: Vector) {
            self.v1 = v1
            self.v2 = v2
        }

        static func == (lhs: Day8.Pair, rhs: Day8.Pair) -> Bool {
            (lhs.v1 == rhs.v1 && lhs.v2 == rhs.v2) ||
            (lhs.v1 == rhs.v2 && lhs.v2 == rhs.v1)
        }

        static func < (lhs: Day8.Pair, rhs: Day8.Pair) -> Bool {
            (lhs.v1 < rhs.v1 && lhs.v2 < rhs.v2) || (lhs.v1 < rhs.v2 && lhs.v2 < rhs.v1)
        }
    }

    public func part1(_ input: [String], iterations: Int) -> Int {
        let boxes = parse(input)
        var distances: [Pair: Double] = [:]

        for v1 in boxes {
            for v2 in boxes {
                let pair = Pair(min(v1, v2), max(v1, v2))
                guard v1 != v2, distances[pair] == nil else { continue }
                distances[pair] = v1.distance(to: v2)
            }
        }

        let sortedDistances = distances.sorted { $0.value < $1.value }
        var groups: [Set<Vector>] = []

        for i in 0..<iterations {
            let pair = sortedDistances[i].key
            groups.append(Set([pair.v1, pair.v2]))

            var grouped = true
            while grouped {
                grouped = false
                outerLoop: for i in 0..<groups.count {
                    let group1 = groups[i]
                    for j in 0..<groups.count where j != i {
                        let group2 = groups[j]

                        if group1.intersection(group2).count > 0 {
                            let group = group1.union(group2)
                            groups.remove(at: max(i, j))
                            groups.remove(at: min(i, j))
                            groups.append(group)
                            grouped = true
                            break outerLoop
                        }
                    }
                }
            }
        }

        let results = groups.map { $0.count }.sorted(by: >)
        var total = 1

        for i in 0..<3 {
            total *= results[i]
        }

        return total
    }

    public func part2(_ input: [String]) -> Int {
        let boxes = parse(input)
        var distances: [Pair: Double] = [:]

        for v1 in boxes {
            for v2 in boxes {
                let pair = Pair(min(v1, v2), max(v1, v2))
                guard v1 != v2, distances[pair] == nil else { continue }
                distances[pair] = v1.distance(to: v2)
            }
        }

        let sortedDistances = distances.sorted { $0.value < $1.value }.map { $0.key }
        var groups: [Set<Vector>] = []

        mainLoop: for pair in sortedDistances {
            groups.append(Set([pair.v1, pair.v2]))

            var grouped = true
            while grouped {
                grouped = false
                outerLoop: for i in 0..<groups.count {
                    let group1 = groups[i]
                    for j in 0..<groups.count where j != i {
                        let group2 = groups[j]

                        if group1.intersection(group2).count > 0 {
                            let group = group1.union(group2)
                            groups.remove(at: max(i, j))
                            groups.remove(at: min(i, j))
                            groups.append(group)
                            grouped = true
                            break outerLoop
                        }
                    }
                }
            }

            if groups.count == 1, groups.first!.count == boxes.count {
                return pair.v1.x * pair.v2.x
            }
        }
        
        return 0
    }
}

extension Day8 {
    func parse(_ input: [String]) -> [Vector] {
        input.map {
            $0.components(separatedBy: ",")
        }
        .map(Vector.init)
    }
}
