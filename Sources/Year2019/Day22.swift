import Foundation
import StandardLibraries

public struct Day22 {
    public init() {}
    
    public enum Technique {
        case dealNewStack
        case cut(Int)
        case dealWithIncrement(Int)
        
        public init(with string: String) {
            if string == "deal into new stack" {
                self = .dealNewStack
            } else if string.hasPrefix("cut") {
                self = .cut(string.getNumber())
            } else if string.hasPrefix("deal with increment") {
                self = .dealWithIncrement(string.getNumber())
            } else {
                preconditionFailure()
            }
        }

        public func apply(to deck: inout [Int]) {
            switch self {
            case .dealNewStack: deck.reverse()
            
            case .cut(let count):
                let n = count < 0 ? deck.count + count : count
                let head = deck.prefix(n)
                let tail = deck.dropFirst(n)
                deck = Array(tail + head)
                
            case .dealWithIncrement(let inc):
                let count = deck.count
                for (offset, card) in deck.enumerated() {
                    deck[(offset * inc) % count] = card
                }
            }
        }
    }
            
    public func part1(_ input: [String]) -> Int {
        let techniques = input.map(Technique.init)
        var deck = Array(0..<10007)
        for technique in techniques {
            technique.apply(to: &deck)
        }
        return deck.firstIndex(of: 2019)!
    }
    
    public func part2(_ input: [String]) -> Int {
        let techniques = input.map(Technique.init).reversed()
        
        let len = BInt(119315717514047) // deck size
        let times = BInt(101741582076661) // number of repititions
        let startpos = BInt(2020)
        var pos = startpos
        var t = 0
        var olda: BInt?, oldb: BInt?

        while true {
            var a = BInt(1), b = BInt(0)
            for technique in techniques {
                switch technique {
                case .dealNewStack:
                    pos = len - 1 - pos
                    a = -a
                    b = -b + len - 1
                    
                case let .cut(n):
                    var n2 = BInt(n)
                    if n < 0 {
                        n2 = len - abs(n2)
                    }
                    pos = (pos + n2) % len
                    b += n2
                    
                case let .dealWithIncrement(n):
                    let ninv = modinv(BInt(n), len)
                    a *= ninv
                    b *= ninv
                    pos = (ninv * pos) % len
                }
            }
            a %= len
            b %= len
            t += 1
            if let olda = olda {
                assert(a == olda && b == oldb)
            }
            olda = a
            oldb = b
            if t > 10 || t == times {
                let answer = (startpos * modpow(a, times, len) + (modpow(a, times, len) - 1) * b * modinv(a-1, len)) % len
                return Int(answer)
            }
        }
    }
}

public func modinv(_ a: BInt, _ m: BInt) -> BInt {
    return modpow(a, m - 2, m)
}

public func modpow(_ b: BInt, _ e: BInt, _ m: BInt) -> BInt {
    if e == 0 {
        return 1
    } else if e % 2 == 0 {
        return modpow((b * b) % m, e / 2, m)
    } else {
        return (b * modpow(b, e - 1, m)) % m
    }
}

extension String {
    func getNumber() -> Int {
        return Int(components(separatedBy: " ").last!)!
    }
}
