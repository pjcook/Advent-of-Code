import Foundation
import StandardLibraries

public struct Day5 {
    public init() {}
    private let vowels = ["a", "e", "i", "o", "u"]
    private let disallowedPairs = ["ab", "cd", "pq", "xy"]
    
    /*
     Nice string:
     • 3 vowels [aeiou]
     • at least 1 letter that appears twice in a row like xx
     • does not contain any of the following: ["ab", "cd", "pq", "xy"]
     */
    public func part1(_ input: [String]) -> Int {
        input.reduce(0) { partialResult, value in
            partialResult + (isNiceString_part1(value) ? 1 : 0)
        }
    }
    
    public func isNiceString_part1(_ value: String) -> Bool {
        var vowelCount = 0
        var hasDouble = false
        var a = ""
        var b = String(value[0])
        
        if vowels.contains(b) {
            vowelCount += 1
        }
        
        for i in (1..<value.count) {
            a = b
            b = String(value[i])
            
            if vowels.contains(b) {
                vowelCount += 1
            }
            
            if disallowedPairs.contains(a + b) {
                return false
            }
            
            if a == b {
                hasDouble = true
            }
        }
        
        return hasDouble && vowelCount > 2
    }
    
    /*
     It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
     It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
     */
    public func part2(_ input: [String]) -> Int {
        input.reduce(0) { partialResult, value in
            partialResult + (isNiceString_part2(value) ? 1 : 0)
        }
    }
    
    public func isNiceString_part2(_ value: String) -> Bool {
        var doubles = [String:Int]()
        var hasRepeat = false
        var a = String(value[0])
        var b = String(value[1])
        var c = String(value[2])
        var n = ""
        
        func check() {
            doubles[b + c] = doubles[b + c, default: 0] + 1
            
            if a == c {
                hasRepeat = true
            }
        }
        
        doubles[a + b] = doubles[a + b, default: 0] + 1
        if !(a == b && b == c) {
            check()
        } else if a == c {
            hasRepeat = true
        }

        for i in (3..<value.count) {
            n = String(value[i])
            
            if a == b && b == c && c == n {
                doubles[b + c] = doubles[b + c, default: 0] + 1
                hasRepeat = true
                a = b
                b = c
                c = n
                continue
            }

            a = b
            b = c
            c = n
            if a == b && b == c {
                hasRepeat = true
                continue
            }
            check()
        }
        
        let hasDouble = (doubles.first(where: { (_, value) in
            value > 1
        })) != nil
        
//        if hasRepeat && hasDouble {
//            print(value, hasRepeat, hasDouble, doubles.first(where: { (_, value) in
//                value > 1
//            })!.key)
//        }
        return hasRepeat && hasDouble
    }
}
