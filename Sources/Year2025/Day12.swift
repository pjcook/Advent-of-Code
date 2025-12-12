import Foundation
import InputReader
import StandardLibraries

public class Day12 {
    public init() {}

    public func part1(_ input: [String]) -> Int {
        parse(input).reduce(0) {
            $0 + (quickCheck(size: $1.size, remaining: $1.presents) ? 1 : 0)
        }
    }

    struct Region {
        let size: Point
        let presents: [Int]

        init(_ line: String) {
            let parts = line.replacingOccurrences(of: ":", with: "")
                .replacingOccurrences(of: "x", with: " ")
                .components(separatedBy: " ")
            self.size = Point(Int(parts[0])!, Int(parts[1])!)
            self.presents = parts[2...].compactMap(Int.init)
        }
    }
}

extension Day12 {
    func quickCheck(size: Point, remaining: [Int]) -> Bool {
        var area = (remaining[0] + remaining[3]) * (3*3)
        area += ((remaining[1] / 2) + (remaining[1] % 2)) * (3*4)
        area += ((remaining[5] / 2) + (remaining[5] % 2)) * (4*4)

        var shape2 = remaining[2]
        var shape4 = remaining[4]
        let pairs = min(shape2, shape4) / 2
        shape2 -= pairs * 2
        shape4 -= pairs * 2
        area += pairs * (3*8)

        if shape2 > 0 {
            area += shape2 * (3*3)
        }

        if shape4 == 1 {
            area += (3*3)
        } else if shape4 > 1 {
            area += ((shape4 / 2) * (3*4)) + ((shape4 % 2) * (3*3))
        }

        return size.x * size.y >= area
    }

    func parse(_ input: [String]) -> [Region] {
        var regions = [Region]()

        for line in input {
            if line.contains("x") {
                regions.append(Region(line))
            }
        }

        return regions
    }
}
