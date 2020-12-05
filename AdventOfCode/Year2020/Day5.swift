import Foundation

public struct Day5 {
    public static func parse(_ input: [String], rows: Int = 128, columns: Int = 8) -> [Int] {
        return input
            .map {
                $0.map {
                    switch $0 {
                    case "F": return "0"
                    case "B": return "1"
                    case "L": return "0"
                    case "R": return "1"
                    default: return ""
                    }
                }
                .reduce("", { $0 + $1 })
            }
            .compactMap { Int($0, radix: 2) }
    }
}
