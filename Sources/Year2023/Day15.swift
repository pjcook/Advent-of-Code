import Foundation
import StandardLibraries

public struct Day15 {
    public init() {}
    
    public func part1(_ input: String) -> Int {
        input
            .components(separatedBy: ",")
            .map(calculateHash)
            .reduce(0, +)
    }
    
    func calculateHash(_ value: String) -> Int {
        value
            .toAscii()
            .reduce(0) { (($0 + $1) * 17) % 256 }
    }
    
    public func part2(_ input: String) -> Int {
        let items = input.components(separatedBy: ",")
        var mappings = [String: Int]()
        var boxes: [[(String, Int)]] = Array(repeating: [], count: 256)
        
        for item in items {
            if item.hasSuffix("-") {
                let key = item.replacingOccurrences(of: "-", with: "")
                if let index = mappings[key] {
                    var boxItems = boxes[index]
                    if let boxItemIndex = boxItems.firstIndex(where: { $0.0 == key }) {
                        boxItems.remove(at: boxItemIndex)
                        boxes[index] = boxItems
                    }
                } else {
                    mappings[key] = calculateHash(key)
                }
            } else {
                let components = item.components(separatedBy: "=")
                let key = String(components[0])
                let value = Int(String(components[1]))!
                let index: Int
                if let mappedIndex = mappings[key] {
                    index = mappedIndex
                } else {
                    index = calculateHash(key)
                    mappings[key] = index
                }
                
                var boxItems = boxes[index]
                if let boxItemIndex = boxItems.firstIndex(where: { $0.0 == key }) {
                    boxItems[boxItemIndex] = (key, value)
                } else {
                    boxItems.append((key, value))
                }
                boxes[index] = boxItems
            }
        }
        
        var sum = 0
        for boxIndex in (0..<boxes.count) {
            let box = boxes[boxIndex]
            for i in (0..<box.count) {
                let item = box[i]
                sum += (boxIndex + 1) * (i + 1) * item.1
            }
        }
        
        return sum
    }
}
