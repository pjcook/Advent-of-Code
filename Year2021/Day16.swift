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

        public func process() -> Int {
            switch typeID {
            case 0: return subPackets.reduce(0, { $0 + $1.process() })
            case 1: return subPackets.reduce(1, { $0 * $1.process() })
            case 2: return subPackets.map { $0.process() }.min()!
            case 3: return subPackets.map { $0.process() }.max()!
            case 4: return value
            case 5: return subPackets[0].process() > subPackets[1].process() ? 1 : 0
            case 6: return subPackets[0].process() < subPackets[1].process() ? 1 : 0
            case 7: return subPackets[0].process() == subPackets[1].process() ? 1 : 0
            default: abort()
            }
        }
    }
    
    public func part1(_ input: String) -> Int {
        var values = convertHexInputToBinary(input)
        let packet = readPacketHeader(&values, depth: 1)
        return packet?.versionCount() ?? 0
    }
    
    public func part2(_ input: String) -> Int {
        var values = convertHexInputToBinary(input)
        let packet = readPacketHeader(&values, depth: 1)
        return packet?.process() ?? 0
    }
    
    public func readPacketHeader(_ input: inout [Int], depth: Int) -> Packet? {
        var packets = [Packet]()
        let version = Int(input[0..<3].map(String.init).joined(), radix: 2)!
        input.removeFirst(3)
        let typeID = Int(input[0..<3].map(String.init).joined(), radix: 2)!
        input.removeFirst(3)

        if typeID == 4 {        // Literal
            return Packet(version: version, typeID: typeID, value: processLiteral(&input, version: version, typeID: typeID, depth: depth), subPackets: packets)
        } else { // operator
            processOperator(&input, depth: depth).forEach { packets.append($0) }
        }

        return Packet(version: version, typeID: typeID, value: 0, subPackets: packets)
    }
    
    public func processOperator(_ input: inout [Int], depth: Int) -> [Packet] {
        let i = input.removeFirst()
        var length = 0
        if i == 0 {     // number of bits in the sub-packets
            length = Int(input[0..<15].map(String.init).joined(), radix: 2)!
            input.removeFirst(15)
            var remainder = Array(input[0..<length])
            input.removeFirst(length)
            var packets = [Packet]()
            while remainder.contains(1) {
                if let packet = readPacketHeader(&remainder, depth: depth + 1) {
                    packets.append(packet)
                } else {
                    break
                }
            }
            return packets
        } else {        // the number of subpackets
            length = Int(input[0..<11].map(String.init).joined(), radix: 2)!
            input.removeFirst(11)
            var packets = [Packet]()
            for _ in (0..<length) {
                if let packet = readPacketHeader(&input, depth: depth + 1) {
                    packets.append(packet)
                }
            }
            return packets
        }
    }
    
    public func processLiteral(_ input: inout [Int], version: Int, typeID: Int, depth: Int) -> Int {
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
        return Int(remainder.map(String.init).joined(), radix: 2)!
    }
    
    public func convertHexInputToBinary(_ input: String) -> [Int] {
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
