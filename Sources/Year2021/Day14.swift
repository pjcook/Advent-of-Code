import Foundation
import StandardLibraries

public struct Day14 {
    public init() {}
    
    /*
     The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.
     
     Starting with the polymer template NNCB, the first step simultaneously considers all three pairs:

     The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
     The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
     The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.
     
     Because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.
     
     This is the NAIVE solution, you can use Part 2 to solve both parts more efficiently.
     */
    public func part1(_ input: [String], steps: Int) -> Int {
        // Parse the input file
        var (template, pairs) = parse(input)
        
        // For the number of steps
        for _ in (0..<steps) {
            var i = 1
            // Create pairs from the previous character and current character, look up the matched value and insert between the two until you get to the end of the line
            while i < template.count {
                let key = template[i-1] + template[i]
                if let value = pairs[key] {
                    template.insert(value, at: i)
                    i += 1
                }
                
                i += 1
            }
        }
        
        // Count up the number of unique characters
        var chars = [String:Int]()
        for char in template {
            chars[char, default: 0] += 1
        }
        // Sort the resulting values so it's easier to get the lowest and highest values
        let sorted = chars.values.sorted()
        // Calculate the answer
        return sorted.last! - sorted.first!
    }
    
    /*
     This solution is much more efficient than the above, has significant less memory requirements and a smaller number of iterative loops
     */
    public func part2(_ input: [String], steps: Int) -> Int {
        // Parse the input file
        let (template, pairs) = parse(input)
        // This will be used to count the number of characters as we go
        var chars = [String:Int]()
        // count the initial char as it will be skipped in the next loop
        chars[template[0], default: 0] += 1
        
        // Process the initial template into pairs and count the chars while your at it
        var found = [String:Int]()
        var i = 1
        while i < template.count {
            let key = template[i-1] + template[i]
            chars[template[i], default: 0] += 1
            found[key, default: 0] += 1
            i += 1
        }
        
        // Now calculate the totals for the desired number of steps
        for _ in (0..<steps) {
            // newFound holds the new list of pairs and their associated counts
            var newFound = [String:Int]()
            // for each pair, calculate the two new pairs and update newFound with the totals and increment the count of the matched character by the current pair count
            for item in found {
                let c = pairs[item.key]!
                chars[c, default: 0] += item.value
                let key1 = String(item.key[0]) + c
                let key2 = c + String(item.key[1])
                newFound[key1, default: 0] += item.value
                newFound[key2, default: 0] += item.value
            }
            found = newFound
        }
        
        // sort the results so it's easier to get the lowest and highest values
        let sorted = chars.values.sorted()
        // calculate the answer
        return sorted.last! - sorted.first!
    }
    
    /*
     The puzzle input offers a polymer template and a list of pair insertion rules
     */
    public func parse(_ input: [String]) -> ([String], [String:String]) {
        let template = input[0].map { String($0) }
        var pairs = [String:String]()
        for i in (2..<input.count) {
            let split = input[i].components(separatedBy: " -> ")
            pairs[split[0]] = split[1]
        }
        return (template, pairs)
    }
}
