import Foundation
import StandardLibraries

public struct Day8 {
    public init() {}
    public typealias Patterns = Grid<Set<Character>>
    /*
    0:      1:      2:      3:      4:
   aaaa    ....    aaaa    aaaa    ....
  b    c  .    c  .    c  .    c  b    c
  b    c  .    c  .    c  .    c  b    c
   ....    ....    dddd    dddd    dddd
  e    f  .    f  e    .  .    f  .    f
  e    f  .    f  e    .  .    f  .    f
   gggg    ....    gggg    gggg    ....

    5:      6:      7:      8:      9:
   aaaa    aaaa    aaaa    aaaa    aaaa
  b    .  b    .  .    c  b    c  b    c
  b    .  b    .  .    c  b    c  b    c
   dddd    dddd    ....    dddd    dddd
  .    f  e    f  .    f  e    f  .    f
  .    f  e    f  .    f  e    f  .    f
   gggg    gggg    ....    gggg    gggg

  
     UNIQUE
     0:      1:      2:      3:      4:
            ....                    ....
           .    c                  b    c
           .    c                  b    c
            ....                    dddd
           .    f                  .    f
           .    f                  .    f
            ....                    ....

     5:      6:      7:      8:      9:
                    aaaa    aaaa
                   .    c  b    c
                   .    c  b    c
                    ....    dddd
                   .    f  e    f
                   .    f  e    f
                    ....    gggg

     FIVE CHARACTERS
     0:      1:      2:      3:      4:
                    aaaa    aaaa
                   .    c  .    c
                   .    c  .    c
                    dddd    dddd
                   e    .  .    f
                   e    .  .    f
                    gggg    gggg

     5:      6:      7:      8:      9:
    aaaa
   b    .
   b    .
    dddd
   .    f
   .    f
    gggg

     
     SIX CHARACTERS
     0:      1:      2:      3:      4:
    aaaa
   b    c
   b    c
    ....
   e    f
   e    f
    gggg

     5:      6:      7:      8:      9:
            aaaa                    aaaa
           b    .                  b    c
           b    .                  b    c
            dddd                    dddd
           e    f                  .    f
           e    f                  .    f
            gggg                    gggg

     
     a  = 7 - 1
     b  = 4 - 1 - d
     c  = (c,d,e) - d - e
     d  = (d,g) - g
     e  = (b,e) - b
     f  = 1 - c
     g  = (d,g) - 4
     
     d,g = (all 5 char count of 3) - 7
     b,e = (all 5 char count 1)
     c,d,e = (all 6 char count 2)
     
     b,d = 4 - 1
     
     1,4,7,8
     
    
     0 6    abcefg
     1 2 -  cf
     2 5    acdeg
     3 5    acdfg
     4 4 -  bcdf
     5 5    abdfg
     6 6    abdefg
     7 3 -  acf
     8 7 -  abcdefg
     9 6    abcdfg
     */
    
    public func part1(_ input: [String]) throws -> Int {
        let grid = try parse(input)
        var count = 0
        for y in (0..<grid.rows) {
            for x in (10..<14) {
                if [2,4,3,7].contains(grid[x,y].count) {
                    count += 1
                }
            }
        }
        return count
    }
    
    public func part2(_ input: [String]) throws -> Int {
        let grid = try parse(input)
        var count = 0
        
        for y in (0..<grid.rows) {
            let dict = mapCharacters(grid, y: y)
            let charMap = translateCharacters(grid, dict: dict)
            let numbers = mapNumbers(charMap: charMap)
            
            let a = numbers[grid[10,y]]!
            let b = numbers[grid[11,y]]!
            let c = numbers[grid[12,y]]!
            let d = numbers[grid[13,y]]!
            
            count += a * 1000 + b * 100 + c * 10 + d
        }
        
        return count
    }
    
    public func part2b(_ input: [String]) throws -> Int {
        let grid = try parse(input)
        var count = 0
        
        for y in (0..<grid.rows) {
            let elements = mapCharacters2(grid, y: y)

            let a = elements[Set(grid[10,y])]!
            let b = elements[Set(grid[11,y])]!
            let c = elements[Set(grid[12,y])]!
            let d = elements[Set(grid[13,y])]!
            
            count += a * 1000 + b * 100 + c * 10 + d
        }
        
        return count
    }
    
    public func mapCharacters2(_ grid: Grid<Set<Character>>, y: Int) -> [Set<Character>: Int] {
        var dict = [Int:Set<Set<Character>>]()
        for x in (0..<10) {
            let value = grid[x,y]
            var values = dict[value.count, default: Set<Set<Character>>()]
            values.insert(value)
            dict[value.count] = values
        }
                
        let one = dict[2]!.first!
        let four = dict[4]!.first!
        let seven = dict[3]!.first!
        let eight = dict[7]!.first!
        
        var sixLEDs = dict[6]!
        var fiveLEDs = dict[5]!

        let nine = sixLEDs.first { $0.isSuperset(of: four) }!
        sixLEDs.remove(nine)
                
        let three = fiveLEDs.first { $0.isSuperset(of: one) }!
        fiveLEDs.remove(three)
        
        let zero = sixLEDs.first { $0.isSuperset(of: one) }!
        sixLEDs.remove(zero)
        
        let six = sixLEDs.first!
        let five = fiveLEDs.first { $0.isSubset(of: nine) }!
        fiveLEDs.remove(five)
        
        let two = fiveLEDs.first!
        
        return [ zero: 0, one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9 ]
    }
    
    public func mapCharacters(_ grid: Grid<Set<Character>>, y: Int) -> [Int: Set<Set<Character>>] {
        var dict = [Int:Set<Set<Character>>]()
        for x in (0..<10) {
            let value = grid[x,y]
            var values = dict[value.count, default: Set<Set<Character>>()]
            values.insert(value)
            dict[value.count] = values
        }
        return dict
    }
    
    public func translateCharacters(_ grid: Grid<Set<Character>>, dict: [Int: Set<Set<Character>>]) -> [Character:Character] {
        var charMap = [Character:Character]()
        
        let one = dict[2]!.first!
        charMap["a"] = Set(dict[3]!.first!).subtracting(Set(one)).first!
        let char5 = charCount(dict[5]!)
        var be = Set(char5.filter({ $0.value == 1 }).map({ $0.key }))
        let four = Set(dict[4]!.first!)
        var dg = Set(char5.filter({ $0.value == 3 }).map({ $0.key })).subtracting(Set(dict[3]!.first!))
        let cde = Set(charCount(dict[6]!).filter({ $0.value == 2 }).map({ $0.key }))

        charMap["g"] = dg.subtracting(four).first
        dg.remove(charMap["g"]!)
        charMap["d"] = dg.first!

        var b = four.subtracting(Set(one))
        b.remove(charMap["d"]!)
        charMap["b"] = b.first!
        be.remove(charMap["b"]!)
        charMap["e"] = be.first!
        
        charMap["c"] = cde.subtracting(Set([charMap["d"]!, charMap["e"]!])).first
        charMap["f"] = Set(one).subtracting([charMap["c"]!]).first
        return charMap
    }
    
    public func mapNumbers(charMap: [Character:Character]) -> [Set<Character>:Int] {
        var numbers = [Set<Character>:Int]()
        
        let a = String(charMap["a"]!)
        let b = String(charMap["b"]!)
        let c = String(charMap["c"]!)
        let d = String(charMap["d"]!)
        let e = String(charMap["e"]!)
        let f = String(charMap["f"]!)
        let g = String(charMap["g"]!)
        
        numbers[Set(a+b+c+e+f+g)] = 0
        numbers[Set(c+f)] = 1
        numbers[Set(a+c+d+e+g)] = 2
        numbers[Set(a+c+d+f+g)] = 3
        numbers[Set(b+c+d+f)] = 4
        numbers[Set(a+b+d+f+g)] = 5
        numbers[Set(a+b+d+e+f+g)] = 6
        numbers[Set(a+c+f)] = 7
        numbers[Set(a+b+c+d+e+f+g)] = 8
        numbers[Set(a+b+c+d+f+g)] = 9
        return numbers
    }
    
    public func charCount(_ input: Set<Set<Character>>) -> [Character:Int] {
        var result = [Character:Int]()
        
        for item in input {
            for c in item {
                result[c] = result[c, default: 0] + 1
            }
        }
        
        return result
    }
    
    public let regex = try! RegularExpression(pattern: "^([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) . ([abcdefg]+) ([abcdefg]+) ([abcdefg]+) ([abcdefg]+)$")
    
    public func parse(_ input: [String]) throws -> Patterns {
            var items = [Set<Character>]()
        
        for line in input {
            let match = try regex.match(line)
            for i in (0..<14) {
                items.append(Set(try match.string(at: i)))
            }
        }
        
        return Patterns(columns: 14, items: items)
    }
}
