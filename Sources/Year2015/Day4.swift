import Foundation
import StandardLibraries

public struct Day4 {
    public init() {}
    
    public func part1(_ input: String, prefix: String = "00000") -> Int? {
        return (0...Int.max).first {
            generateMD5Hash(for: input + String($0)).hasPrefix(prefix)
        }
    }
}
