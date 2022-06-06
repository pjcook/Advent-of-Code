import Foundation
import StandardLibraries

public struct Day16 {
    public init() {}
    
    public func part1(_ input: [String], tickerTape: [String:Int]) throws -> Int {
        let info = try parse(input)
        
    outerLoop: for (index, i) in info.enumerated() {
            for item in i {
                if let found = tickerTape[item.key] {
                    if found != item.value {
                        continue outerLoop
                    }
                } else {
                    continue outerLoop
                }
            }
         return index + 1
        }
        
        return -1
    }
    
    public func part2(_ input: [String]) throws -> Int {
        let info = try parse(input)
        
        var newInfo = info
        var tickerTape = [
            "children": 3,
//            "cats": 7,
            "samoyeds": 2,
//            "pomeranians": 3,
            "akitas": 0,
            "vizslas": 0,
//            "goldfish": 5,
//            "trees": 3,
            "cars": 2,
            "perfumes": 1
        ]
        
        for item in tickerTape {
            newInfo = newInfo.filter {
                $0[item.key, default: item.value] == item.value
            }
        }
        
        tickerTape = [
            "cats": 7,
            "trees": 3
        ]
        
        for item in tickerTape {
            newInfo = newInfo.filter {
                $0[item.key, default: item.value+1] > item.value
            }
        }
        
        tickerTape = [
            "pomeranians": 3,
            "goldfish": 5,
        ]
        
        for item in tickerTape {
            newInfo = newInfo.filter {
                $0[item.key, default: item.value-1] < item.value
            }
        }
        
        return (info.firstIndex(of: newInfo[0]) ?? 0) + 1
    }
    
    public func parse(_ input: [String]) throws -> [[String:Int]] {
        var info = [[String:Int]]()
        let regex = try RegularExpression(pattern: "^\\w+ \\d+: (\\w+): (\\d+), (\\w+): (\\d+), (\\w+): (\\d+)$")
        
        for line in input {
            let match = try regex.match(line)
            var i = [String:Int]()
            i[try match.string(at: 0)] = try match.integer(at: 1)
            i[try match.string(at: 2)] = try match.integer(at: 3)
            i[try match.string(at: 4)] = try match.integer(at: 5)
            info.append(i)
        }
        
        return info
    }
}
