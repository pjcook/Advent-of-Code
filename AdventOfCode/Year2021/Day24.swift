import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    /*
     So I don't actually think there is a sensible programmatic way to solve this puzzle. The solution to the problem is to look at the input file, figure out that there are 14 sections to the program denoted by the `inp` instructions. Each `inp` instruction would want the next digit from your `modelNumber`.
     
     Looking at the program in detail, you can break it down to see that the program sections are all identical apart from 3 numbers which we will call A, B, C
     
     Variable `A` is effectively the number at the end of line 5 and will be either 1 or 26. These ultimately equate to pops and pushes, more on this later.
     Variable `B` is the value at the end of line 6.
     Variable `C` is the value at the end of line 16.
     
     Draw a grid using these numbers line in the `validate` function below.
     
     You then need to align the pops and pushes by matching the nearest `pop` to the nearest `push`.
     
     In my input below this is:
     
     [01] 1   ---------\
     [02] 1   -------\ |
     [03] 1   -----\ | |
     [04] 1   ---\ | | |
     [05] 1   -\ | | | |
     [06] 26  -/ | | | |
     [07] 1   -\ | | | |
     [08] 26  -/ | | | |
     [09] 26  ---/ | | |
     [10] 26  -----/ | |
     [11] 1   -\     | |
     [12] 26  -/     | |
     [13] 26  -------/ |
     [14] 26  ---------/
     
     The formulas to calculate the correct digits are then:
     [01] + [01.C] + [14.B]    ==>    [01] + 5 - 13 = [14]   ==>   9 + 5 - 13 = 1
     [02] + [02.C] + [13.B]    ==>    [02] + 5 - 2 = [13]    ==>   6 + 5 - 2  = 9
     [03] + [03.C] + [10.B]    ==>    [03] + 1 - 8 = [10]    ==>   9 + 1 - 8  = 2
     [04] + [04.C] + [09.B]    ==>    [04] + 15 - 7 = [09]   ==>   1 + 15 - 7 = 9
     [05] + [05.C] + [06.B]    ==>    [05] + 2 - 1 = [06]    ==>   8 + 2 - 1  = 9
     [06]                                                          9
     [07] + [07.C] + [08.B]    ==>    [07] + 5 - 8 = [08]    ==>   9 + 5 - 8  = 6
     [08]                                                          6
     [09]                                                          9
     [10]                                                          2
     [11] + [11.C] + [12.B]    ==>    [11] + 7 - 2 = [12]    ==>   4 + 7 - 2  = 9
     [12]                                                          9
     [13]                                                          9
     [14]                                                          1
     
     For Part 2, use the above formulas, but try putting the smallest number possible from 1-9 into the `push` positions.
     */
    
    public struct IntALU {
        public var x: Int = 0
        public var y: Int = 0
        public var z: Int = 0
        public init() {}
    }
    
    public func validate(_ bits: [Int], triples: [Triple]) -> Int {
        var alu = IntALU()
        for i in (0..<bits.count) {
            alu = execute(w: bits[i], a: triples[i].a, b: triples[i].b, c: triples[i].c, alu: alu)
        }
        return alu.z
    }
    
    public func execute(w: Int, a: Int, b: Int, c: Int, alu: IntALU) -> IntALU {
        var alu = alu
        alu.x = ((alu.z % 26) + b) == w ? 0 : 1
        alu.y = (w + c) * alu.x
        alu.z = (alu.z / a) * (25 * alu.x + 1) + alu.y
        return alu
    }
    
    public struct Triple {
        public let a: Int
        public let b: Int
        public let c: Int
    }
    
    public struct Mapping {
        public let a: Int
        public let b: Int
    }
    
    public func calculateMin(_ triples: [Triple], _ mapping: [Mapping]) -> [Int] {
        var bits = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        for map in mapping {
            let index1 = map.a
            let index2 = map.b
            let c = triples[index1].c
            let b = triples[index2].b
            
            var x = 1
            while x <= 9 {
                if (1...9).contains(x + c + b) {
                    break
                }
                x += 1
            }
            bits[index1] = x
            bits[index2] = x + c + b
        }
        
        return bits
    }
    
    public func calculateMax(_ triples: [Triple], _ mapping: [Mapping]) -> [Int] {
        var bits = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        
        for map in mapping {
            let index1 = map.a
            let index2 = map.b
            let c = triples[index1].c
            let b = triples[index2].b
            
            var x = 9
            while x > 0 {
                if (1...9).contains(x + c + b) {
                    break
                }
                x -= 1
            }
            bits[index1] = x
            bits[index2] = x + c + b
        }
        
        return bits
    }
    
    public func createMapping(_ triples: [Triple]) -> [Mapping] {
        var doubles = [Mapping]()
        var indexes = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
        
        while !indexes.isEmpty {
            for i in (0..<indexes.count) {
                let a = triples[indexes[i]].a
                let b = triples[indexes[i+1]].a
                if a == 1, b == 26 {
                    doubles.append(Mapping(a: indexes[i], b: indexes[i+1]))
                    indexes.remove(at: i)
                    indexes.remove(at: i)
                    break
                }
            }
        }
        
        return doubles
    }
    
    public func parse(_ input: [String]) -> [Triple] {
        var triples = [Triple]()
        var i = 0
        while i < input.count {
            let a = Int(String(input[i+4].split(separator: " ").last!))!
            let b = Int(String(input[i+5].split(separator: " ").last!))!
            let c = Int(String(input[i+15].split(separator: " ").last!))!
            triples.append(Triple(a: a, b: b, c: c))
            i += 18
        }
        
        return triples
    }
}
