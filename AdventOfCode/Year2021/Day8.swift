import Foundation
import StandardLibraries

public struct Day8 {
    public init() {}
    public typealias Patterns = Grid<String>
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
     b  = (any with 5) = x - 1 (item with count 1)
     c  = (c,d,e) - d - e
     d  = (d,g) - g
     e  = (b,e) - b
     f  = 1 - c
     g  = (d,g) - 4
     
     d,g = (all 5 char count of 3) - 1
     b,e = (all 5 char count 1)
     c,d,e = (all 6 char count 1)
     
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
            
            var number = ""
            for x in (10..<14) {
                number.append(String(numbers[grid[x,y]]!))
            }
            count += Int(number)!
        }
        
        return 0
    }
    
    public func mapCharacters(_ grid: Grid<String>, y: Int) -> [Int: Set<String>] {
        var dict = [Int:Set<String>]()
        for x in (0..<grid.columns) {
            let value = grid[x,y]
            var values = dict[value.count, default: Set<String>()]
            values.insert(value)
            dict[value.count] = values
        }
        return dict
    }
    
    public func translateCharacters(_ grid: Grid<String>, dict: [Int: Set<String>]) -> [Character:Character] {
        var charMap = [Character:Character]()
        
        let one = dict[2]!.first!
        charMap["a"] = discreet(value1: dict[3]!.first!, value2: one)
        let char5 = charCount(dict[5]!)
        var be = Set(char5.filter({ $0.value == 1 }).map({ $0.key }))
        let four = Set(dict[4]!.first!)
        charMap["e"] = be.subtracting(four).first!
        charMap["b"] = be.remove(charMap["e"]!)
        
        var dg = Set(char5.filter({ $0.value == 3 }).map({ $0.key })).subtracting(Set(one))
        charMap["g"] = dg.subtracting(four).first
        charMap["d"] = dg.remove(charMap["g"]!)

        let cde = Set(charCount(dict[6]!).filter({ $0.value == 2 }).map({ $0.key }))
        
        charMap["c"] = cde.subtracting(Set([charMap["d"]!, charMap["e"]!])).first
        charMap["f"] = Set(one).subtracting([charMap["c"]!]).first
        return charMap
    }
    
    public func mapNumbers(charMap: [Character:Character]) -> [String:Int] {
        var numbers = [String:Int]()
        
        let a = String(charMap["a"]!)
        let b = String(charMap["b"]!)
        let c = String(charMap["c"]!)
        let d = String(charMap["d"]!)
        let e = String(charMap["e"]!)
        let f = String(charMap["f"]!)
        let g = String(charMap["g"]!)
        
        numbers[String((a+b+c+e+f+g).sorted())] = 0
        numbers[String((c+f).sorted())] = 1
        numbers[String((a+c+d+e+g).sorted())] = 2
        numbers[String((a+c+d+f+g).sorted())] = 3
        numbers[String((b+c+d+f).sorted())] = 4
        numbers[String((a+b+d+f+g).sorted())] = 5
        numbers[String((a+b+d+e+f+g).sorted())] = 6
        numbers[String((a+c+f).sorted())] = 7
        numbers[String((a+b+c+d+e+f+g).sorted())] = 8
        numbers[String((a+b+c+d+f+g).sorted())] = 9
        return numbers
    }
    
    public func discreet(value1: String, value2: String) -> Character {
        let s1 = Set(value1)
        let s2 = Set(value2)
        let i = s1.subtracting(s2)
        return Character(String(i.first!))
    }
    
    public func charCount(_ input: Set<String>) -> [Character:Int] {
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
            var items = [String]()
        
        for line in input {
            let match = try regex.match(line)
            for i in (0..<14) {
                items.append(String(try match.string(at: i).sorted()))
            }
        }
        
        return Patterns(columns: 14, items: items)
    }
}
