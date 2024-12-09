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
        let input2 = input.map { Int(String($0))! }
        var (disk, _) = writeDiskContents(input2)

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
        let input2 = input.map { Int(String($0))! }
        var (disk, index) = writeDiskContents(input2)
        
        // compact disk
        var highestLookupIndex = disk.count
        outerloop: for i in (1..<index).reversed() {
            var nextIndexes = [Int]()
            for j in (0..<highestLookupIndex).reversed() {
                if disk[j] == .value(i) {
                    nextIndexes.append(j)
                } else if nextIndexes.count > 0 {
                    highestLookupIndex = j+1
                    break
                }
            }            
            
            let itemCount = nextIndexes.count
            let lowestIndexPosition = nextIndexes.sorted().first!

            // find contiguous block of free space large enough
            var startIndex = -1
            guard let lowestFreeSpaceIndex = disk.firstIndex(of: .free), lowestFreeSpaceIndex < lowestIndexPosition else { break outerloop }
            for j in (lowestFreeSpaceIndex..<lowestIndexPosition) {
                if disk[j] == .free {
                    if startIndex == -1 {
                        startIndex = j
                    }
                    if j - startIndex + 1 == itemCount {                        
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

extension Day9 {
    func writeDiskContents(_ input: [Int]) -> ([Option], Int) {
        var disk = [Option]()
        var index = 0
        var position = 0
        
        // write disk contents
        while position < input.count {
            let value = input[position]
            position += 1
            
            for _ in (0..<value) {
                disk.append(.value(index))
            }
            
            index += 1
            
            if position >= input.count {
                break
            }
            
            let value2 = input[position]
            position += 1
            
            for _ in (0..<value2) {
                disk.append(.free)
            }
        }
        
        return (disk, index)
    }
}
