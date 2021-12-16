import Foundation
import StandardLibraries

public struct Day16 {
    public init() {}
    
    public struct Packet {
        public let version: Int
        public let typeID: Int
        public let value: Int
        public let subPackets: [Packet]
        
        public func versionCount() -> Int {
            return version + subPackets.reduce(0, { $0 + $1.versionCount() })
        }
        
        public func valueCount() -> Int {
            return value + subPackets.reduce(0, { $0 + $1.valueCount() })
        }
    }
    
    public func part1(_ input: String) -> Int {
        var values = parse(input)
        let packet = processPacket(&values, depth: 1)
        return packet?.versionCount() ?? 0
    }
    
    public func part2(_ input: String) -> Int {
        return 0
    }
    
    public func processPacket(_ input: inout [Int], depth: Int) -> Packet? {
        guard input.count > 6 else {
            input = []
            return nil
        }
        var packets = [Packet]()
        let version = Int(input[0..<3].map(String.init).joined(), radix: 2)!
        input.removeFirst(3)
        let typeID = Int(input[0..<3].map(String.init).joined(), radix: 2)!
        input.removeFirst(3)
        print(depth, version, typeID)
        if typeID == 4 {        // Literal
            packets.append(processLiteral(&input, version: version, typeID: typeID, depth: depth))
        } else { // operator
            processOperator(&input, depth: depth).forEach { packets.append($0) }
        }
        
        while !input.isEmpty {
            if let packet = processPacket(&input, depth: depth + 1) {
                packets.append(packet)
            }
        }

        return Packet(version: version, typeID: typeID, value: 0, subPackets: packets)
    }
    
    public func processOperator(_ input: inout [Int], depth: Int) -> [Packet] {
        guard input.count > 11 else {
            input = []
            return []
        }
        let i = input.removeFirst()
        var length = 0
        if i == 0 {     // number of bits in the sub-packets
            length = Int(input[0..<15].map(String.init).joined(), radix: 2)!
            input.removeFirst(15)
            var remainder = Array(input[0..<length])
            input.removeFirst(length)
            if let packet = processPacket(&remainder, depth: depth + 1) {
                return [packet]
            } else {
                return []
            }
        } else {        // the number of subpackets
            length = Int(input[0..<11].map(String.init).joined(), radix: 2)!
            input.removeFirst(11)
            var packets = [Packet]()
            for _ in (0..<length) {
                if let packet = processPacket(&input, depth: depth + 1) {
                    packets.append(packet)
                }
            }
            return packets
        }
    }
    
    public func processLiteral(_ input: inout [Int], version: Int, typeID: Int, depth: Int) -> Packet {
        var shouldLoop = true
        var remainder = [Int]()
        while shouldLoop {
            let next = input[0..<5]
            input.removeFirst(5)
            if next[0] == 1 {
                next[1...].forEach { remainder.append($0) }
            } else {
                next[1...].forEach { remainder.append($0) }
                shouldLoop = false
            }
        }
        return Packet(version: 0, typeID: 0, value: Int(remainder.map(String.init).joined(), radix: 2)!, subPackets: [])
    }
    
    public func parse(_ input: String) -> [Int] {
        var results = [[Int]]()
        for x in input {
            var values = [Int]()
            for c in String(Int(String(x), radix: 16)!, radix: 2) {
                values.append(Int(String(c))!)
            }
            while values.count < 4 {
                values.insert(0, at: 0)
            }
            results.append(values)
        }
        return results.reduce([], +)
    }
}
