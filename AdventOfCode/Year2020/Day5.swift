import Foundation

public struct Day5 {
    public static func parse(_ input: [String], rows: Int = 128, columns: Int = 8) -> [Int] {
        return input
            .map {
                $0
                    .replacingOccurrences(of: "F", with: "0")
                    .replacingOccurrences(of: "B", with: "1")
                    .replacingOccurrences(of: "L", with: "0")
                    .replacingOccurrences(of: "R", with: "1")
            }
            .compactMap { Int($0, radix: 2) }
    }
}
