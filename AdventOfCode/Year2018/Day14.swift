import Foundation
import StandardLibraries

public struct Day14 {
    public init() {}
    
    public func part1(_ input: Int, iterations: Int) -> Int {
        var list = [Int]()
        
        func append(_ input: String) {
            for c in input {
                list.append(Int(String(c))!)
            }
        }
                
        let input = String(input)
        append(input)
        
        var elf1 = 0
        var elf2 = 1
        
        func move(_ elf: Int) -> Int {
            let steps = list[elf] + 1
            return (elf + steps) % list.count
        }

        while list.count < iterations + 11 {
            let value = String(list[elf1] + list[elf2])
            append(value)
            elf1 = move(elf1)
            elf2 = move(elf2)
            if list.count % 10000 == 0 {
                print(list.count)
            }
        }
        
        return Int((iterations..<iterations+10).map({ String(list[$0]) }).joined())!
    }
    
    public func part2(_ input: Int, iterations: Int) -> Int {
        var list = [Int]()
        var search = [Int]()
        
        func append(_ input: String) {
            for c in input {
                list.append(Int(String(c))!)
            }
        }
                
        let input = String(input)
        append(input)
        
        for c in String(iterations) {
            search.append(Int(String(c))!)
        }
        
        var elf1 = 0
        var elf2 = 1
        
        func move(_ elf: Int) -> Int {
            let steps = list[elf] + 1
            return (elf + steps) % list.count
        }
        
        while list.count - search.count < 0 {
            let value = String(list[elf1] + list[elf2])
            append(value)
            elf1 = move(elf1)
            elf2 = move(elf2)
        }

        while true {
            let count = list.count
            let value = String(list[elf1] + list[elf2])
            append(value)
            elf1 = move(elf1)
            elf2 = move(elf2)
            for i in (0..<list.count - count) {
                if Array(list[count-search.count+i..<count+i]) == search {
                    return count-search.count+i
                }
            }
        }
    }
}
