import Foundation
import StandardLibraries

// position.z is vertical axis
public struct Day22 {
    public init() {}
    
    public func part1(_ input: [Int]) -> Int {
        input.reduce(0) { $0 + calculateSecret($1, at: 2000)}
    }
    
    public func part2(_ input: [Int]) -> Int {
//        print("calculate sequences", Date())
        let sequences = input.map { calculateSecrets($0, 2000).map({ Int(String(String($0).last!))! }) }
        var dxSequences = [[Int]]()
//        print("calculate dxSequences", Date())
        for seq in sequences {
            var dxSeq: [Int] = [0]
            var i = 1
            var current = seq[0]
            while i < seq.count {
                let next = seq[i]
                dxSeq.append(next - current)
                current = next
                i += 1
            }
            dxSequences.append(dxSeq)
        }
        
//        print("calculate lookupLists", Date())
        let listCount = dxSequences[0].count
        var lookupLists = [[[Int]: Int]]()
        for seqIndex in 0..<sequences.count {
            let seq = dxSequences[seqIndex]
            var lookupList: [[Int]: Int] = [:]
            var i = 4
            while i < listCount {
                let a = seq[i-3]
                let b = seq[i-2]
                let c = seq[i-1]
                let d = seq[i]
                let list = [a, b, c, d]
                if lookupList[list] == nil {
                    lookupList[list] = sequences[seqIndex][i]
                }
                i += 1
            }
            lookupLists.append(lookupList)
        }
        
//        print("calculate keys", Date())
        var keys: Set<[Int]> = []
        for list in lookupLists {
            list.keys.forEach { keys.insert($0) }
        }
        
//        print("calculate highestScore", Date())
        var highestScore = 0
        var i = 0
        for key in keys {
            i += 1
            var value = 0
            for list in lookupLists {
                if let v = list[key] {
                    value += v
                }
            }
            if value > highestScore {
                highestScore = value
                print(i, keys.count, highestScore, Date())
            }
            if i % 1000 == 0 {
                print(i, Date())
            }
        }
        
        return highestScore
    }
    
    /*
     Calculate the result of multiplying the secret number by 64. Then, `mix` this result into the secret number. Finally, `prune` the secret number.
     Calculate the result of dividing the secret number by 32. Round the result down to the nearest integer. Then, `mix` this result into the secret number. Finally, `prune` the secret number.
     Calculate the result of multiplying the secret number by 2048. Then, `mix` this result into the secret number. Finally, `prune` the secret number.
     
     To `mix` a value into the secret number, calculate the bitwise XOR of the given value and the secret number. Then, the secret number becomes the result of that operation. (If the secret number is 42 and you were to mix 15 into the secret number, the secret number would become 37.)
     To `prune` the secret number, calculate the value of the secret number modulo 16777216. Then, the secret number becomes the result of that operation. (If the secret number is 100000000 and you were to `prune` the secret number, the secret number would become 16113920.)
     */
}

extension Day22 {
    public func calculateSecrets(_ value: Int, _ numberOfSecrets: Int) -> [Int] {
        var results = [Int]()
        var secret = value
        for _ in 0..<numberOfSecrets {
            secret = calculateSecret(secret)
            results.append(secret)
        }
        return results
    }
    
    public func calculateSecret(_ value: Int, at iterations: Int) -> Int {
        var secret = value
        for _ in 0..<iterations {
            secret = calculateSecret(secret)
        }
        return secret
    }
    
    public func calculateSecret(_ value: Int) -> Int {
        var secret = prune(mix(value * 64, value))
        secret = prune(mix(secret / 32, secret))
        return prune(mix(secret * 2048, secret))
    }
    
    public func mix(_ secret: Int, _ value: Int) -> Int {
        secret ^ value
    }
    
    public func prune(_ value: Int) -> Int {
        value % 16777216
    }
}
