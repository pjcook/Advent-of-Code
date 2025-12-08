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

        var distance: Double {
            v1.distance(to: v2)
        }
    }

    public func part1(_ input: [String], iterations: Int) -> Int {
        let boxes = parse(input).sorted(by: <)
        var pairs: Set<Pair> = []

        for i in 0..<boxes.count {
            let v1 = boxes[i]
            for j in i+1..<boxes.count {
                let v2 = boxes[j]
                pairs.insert(Pair(v1, v2))
            }
        }

        let sortedDistances = pairs.sorted { $0.distance < $1.distance }
        var groups: [Set<Vector>] = []

        for i in 0..<iterations {
            let pair = sortedDistances[i]
            var newGroup = Set([pair.v1, pair.v2])
            var newGroups: [Set<Vector>] = []

            for group in groups {
                if group.intersection(newGroup).count > 0 {
                    newGroup = newGroup.union(group)
                } else {
                    newGroups.append(group)
                }
            }

            newGroups.append(newGroup)
            groups = newGroups
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
        var pairs: Set<Pair> = []

        for i in 0..<boxes.count {
            let v1 = boxes[i]
            for j in i+1..<boxes.count {
                let v2 = boxes[j]
                pairs.insert(Pair(v1, v2))
            }
        }

        let sortedDistances = pairs.sorted { $0.distance < $1.distance }
        var groups: [Set<Vector>] = []

        mainLoop: for pair in sortedDistances {
            var newGroup = Set([pair.v1, pair.v2])
            var newGroups: [Set<Vector>] = []

            for group in groups {
                if group.intersection(newGroup).count > 0 {
                    newGroup = newGroup.union(group)
                } else {
                    newGroups.append(group)
                }
            }

            newGroups.append(newGroup)
            groups = newGroups

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
