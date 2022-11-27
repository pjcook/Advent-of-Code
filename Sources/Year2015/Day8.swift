import Foundation
import StandardLibraries

public struct Day8 {
    public init() {}
    
    public static let hexRegex = try! RegularExpression(pattern: "(?:[^\\\\]|[\\\\\\\\]|\\w)(\\\\x[0-9|a-f]{2})")
    
    public func part1(_ input: [String]) throws -> Int {
        var codeSize = 0
        var memorySize = 0
        
        for line in input {
            codeSize += line.count
            memorySize += try parse(line).count
        }
        
        return codeSize - memorySize
    }
    
    public func part2(_ input: [String]) throws -> Int {
        var codeSize = 0
        var encodedSize = 0
        
        for line in input {
            codeSize += line.count
            let encoded = line.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
            encodedSize += 2 + encoded.count
        }
        
        return encodedSize - codeSize
    }
    
    public func parse(_ value: String) throws -> String {
        var updated = value
        var found = true
        while found {
            found = false
            let matches = Self.hexRegex.matches(in: updated)
            _ = try matches.map {
                if $0.captureGroups.count != 0 {
                    found = true
                    let match = try $0.string(at: 0)
                    updated = updated.replacingOccurrences(of: match, with: hex2ascii(input: match.replacingOccurrences(of: "\\x", with: "")))
//                    updated = updated.replacingOccurrences(of: match, with: "*")
                }
            }
        }
        updated = updated.replacingOccurrences(of: "\\\"", with: "\"")
        updated = updated.replacingOccurrences(of: "\\\\", with: "\\")
        updated = String(updated.dropFirst())
        updated = String(updated.dropLast())
        return updated
    }
    
    public func hex2ascii(input: String) -> String {
        var chars = [Character]()

        for c in input {
            chars.append(c)
        }

        let numbers =  stride(from: 0, to: chars.count, by: 2).map{
            strtoul(String(chars[$0 ..< $0+2]), nil, 16)
        }

        var final = ""
        var i = 0

        while i < numbers.count {
            final.append(Character(UnicodeScalar(Int(numbers[i]))!))
            i += 1
        }

        return final
    }
}
