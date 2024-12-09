import Foundation
import StandardLibraries

public struct Day9 {
    public init() {}
    
    enum Option: Equatable {
        case value(Int)
        case free
        
        func value() -> Int {
            switch self {
            case .value(let value):
                return value
            case .free:
                return 0
            }
        }
    }
    
    public func part1(_ input: String) -> Int {
        var index = 0
        var position = 0
        var disk = [Option]()
        let input2 = input.map { Int(String($0))! }
        
        // write disk contents
        while position < input2.count {
            let value = input2[position]
            position += 1
            
            for _ in (0..<value) {
                disk.append(.value(index))
            }
            
            index += 1
            
            if position >= input2.count {
                break
            }
            
            let value2 = input2[position]
            position += 1
            
            for _ in (0..<value2) {
                disk.append(.free)
            }
        }
        
        // compact disk
        while let freeIndex = disk.firstIndex(of: .free) {
            let value = disk.removeLast()
            if value == .free {
                continue
            }
            disk[freeIndex] = value
        }
        
        // calculate checksum
        var checksum = 0
        for i in (0..<disk.count) {
            checksum += disk[i].value() * i
        }
        
        return checksum
    }
    
    public func part2(_ input: String) -> Int {
        var index = 0
        var position = 0
        var disk = [Option]()
        let input2 = input.map { Int(String($0))! }
        
        // write disk contents
        while position < input2.count {
            let value = input2[position]
            position += 1
            
            for _ in (0..<value) {
                disk.append(.value(index))
            }
            
            index += 1
            
            if position >= input2.count {
                break
            }
            
            let value2 = input2[position]
            position += 1
            
            for _ in (0..<value2) {
                disk.append(.free)
            }
        }
        
        // compact disk
        outerloop: for i in (1..<index).reversed() {
            var nextIndexes = [Int]()
            for j in (0..<disk.count).reversed() {
                if disk[j] == .value(i) {
                    nextIndexes.append(j)
                } else if nextIndexes.count > 0 {
                    break
                }
            }            
            
            let itemCount = nextIndexes.count

            // find contiguous block of free space large enough
            var startIndex = -1
            for j in (0..<disk.count) {
                if disk[j] == .free {
                    if startIndex == -1 {
                        startIndex = j
                    }
                    if j - startIndex + 1 == itemCount {
                        guard startIndex < nextIndexes.sorted().first! else {
                            continue outerloop
                        }
                        
                        for k in (startIndex..<startIndex+itemCount) {
                            disk[k] = .value(i)
                        }
                        
                        for k in nextIndexes {
                            disk[k] = .free
                        }
                        
                        continue outerloop
                    }
                } else {
                    startIndex = -1
                }
            }
        }
        
        // calculate checksum
        var checksum = 0
        for i in (0..<disk.count) {
            checksum += disk[i].value() * i
        }
        
        return checksum
    }
}
