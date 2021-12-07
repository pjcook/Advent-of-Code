import Foundation
import StandardLibraries

public struct Day6 {
    public init() {}
    
    public func part1(_ input: [Int], days: Int) -> Int {
        var fishes = input
        for _ in (0..<days) {
            for (index, fish) in fishes.enumerated() {
                let timer = fish - 1
                fishes[index] = timer
                if timer == -1 {
                    fishes.append(8)
                    fishes[index] = 6
                }
            }
        }
        return fishes.count
    }
    
    public func part2(_ input: [Int], days: Int) -> Int {
        var fishes = Array(repeating: 0, count: 9)
        for i in input {
            fishes[i] = fishes[i] + 1
        }
        for _ in (0..<days) {
            let value = fishes.removeFirst()
            fishes[6] = fishes[6] + value
            fishes.append(value)
            print(fishes)
        }
        return fishes.reduce(0, +)
    }
    
    public func part2b(_ input: [Int], days: Int) -> Int {
        var fishes = Array(repeating: 0, count: 9)
        for i in input {
            fishes[i] = fishes[i] + 1
        }
        let array = CircluarArray(fishes)
        array.increment()
        for _ in (0..<days) {
            let value = array.current
            array.increment()
            let index = array.index(byAdding: 6)
            array.update(value + array.value(at: index), at: index)
            array.update(value, at: array.index(byAdding: -1))
            print(array)
        }
        return fishes.reduce(0, +)
    }
}

public class CircluarArray<Value: Hashable>: Hashable, CustomDebugStringConvertible {
    public static func == (lhs: CircluarArray<Value>, rhs: CircluarArray<Value>) -> Bool {
        lhs.values == rhs.values
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(values)
        hasher.combine(index)
    }
    
    private var values: [Value]
    private var index = 0
    
    public var allValues: [Value] {
        values
    }
    
    public var currentIndex: Int {
        index
    }
    
    public var current: Value {
        values[index]
    }
    
    public init(_ values: [Value]) {
        self.values = values
    }
    
    public func increment() {
        guard !values.isEmpty else { return }
        index += 1
        if index >= values.count {
            index = 0
        }
    }
    
    public func value(at: Int) -> Value {
        values[at]
    }
    
    public func update(_ value: Value, at: Int) {
        values[at] = value
    }
    
    public func index(byAdding value: Int) -> Int {
        let newIndex = index + value
        if newIndex >= values.count {
            return newIndex - values.count
        } else if newIndex < 0 {
            return newIndex + values.count
        }
        return newIndex
    }
    
    public var debugDescription: String {
        "\(values)"
    }
}
