import Foundation
import StandardLibraries
import CryptoKit

public struct Day4 {
    public init() {}
    
    public func part1(_ input: String, prefix: String = "00000") -> Int? {
        return (0...Int.max).first {
            let md5 = Insecure.MD5.hash(data: (input + String($0)).data(using: .utf8)!)
            let hash = md5.map { String(format: "%02hhx", $0) }.joined()
            return hash.hasPrefix(prefix)
        }
    }
}
