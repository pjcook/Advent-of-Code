import Foundation
import StandardLibraries

public struct Day7 {
    public init() {}
    
    enum WinningHandType: Int {
        case highCard       = 0
        case onePair        = 1
        case twoPair        = 2
        case threeOfAKind   = 3
        case fullHouse      = 4
        case fourOfAKind    = 5
        case fiveOfAKind    = 6
    }
    
    struct Hand {
        let cards: String
        let handType: WinningHandType
        let bid: Int
    }
    
    public func part1(_ input: [String]) -> Int {
        calculateAnswer(input, useJokers: false, cardStrength: cardStrengthPart1)
    }
    
    public func part2(_ input: [String]) -> Int {
        calculateAnswer(input, useJokers: true, cardStrength: cardStrengthPart2)
    }
    
    func calculateAnswer(_ input: [String], useJokers: Bool, cardStrength: [String:Int]) -> Int {
        let hands = parse(input, useJokers: useJokers)
            .sorted(by: { sortHands(lhs: $0, rhs: $1, cardStrength: cardStrength) })
        var sum = 0
        for (index, hand) in hands.enumerated() {
            let rank = index + 1
            sum += hand.bid * rank
        }
        return sum
    }
    
    func sortHands(lhs: Hand, rhs: Hand, cardStrength: [String:Int]) -> Bool {
        if lhs.handType == rhs.handType {
            for i in (0..<lhs.cards.count) {
                let lhsCardStrength = cardStrength[String(lhs.cards[i]), default: 0]
                let rhsCardStrength = cardStrength[String(rhs.cards[i]), default: 0]
                
                if lhsCardStrength == rhsCardStrength {
                    continue
                }
                return lhsCardStrength < rhsCardStrength
            }
            // they match completely so keep existing order
            return true
        }
        
        return lhs.handType.rawValue < rhs.handType.rawValue
    }
    
    let cardStrengthPart1 = [
        "2":1,
        "3":2,
        "4":3,
        "5":4,
        "6":5,
        "7":6,
        "8":7,
        "9":8,
        "T":9,
        "J":10,
        "Q":11,
        "K":12,
        "A":13
    ]
    
    let cardStrengthPart2 = [
        "2":1,
        "3":2,
        "4":3,
        "5":4,
        "6":5,
        "7":6,
        "8":7,
        "9":8,
        "T":9,
        "J":0,
        "Q":11,
        "K":12,
        "A":13
    ]
}

extension Day7 {
    func parse(_ input: [String], useJokers: Bool) -> [Hand] {
        var hands = [Hand]()
        
        for line in input {
            let components = line.components(separatedBy: " ")
            let handType = calculateWinningHandType(from: components[0], useJokers: useJokers)
            let hand = Hand(cards: components[0], handType: handType, bid: Int(String(components[1]))!)
            hands.append(hand)
        }
        
        return hands
    }
    
    func calculateWinningHandType(from cards: String, useJokers: Bool) -> Day7.WinningHandType {
        var components = [Character:Int]()
        for card in cards {
            components[card] = components[card, default: 0] + 1
        }
        
        if useJokers, components.count > 1, let jokerCount = components["J"] {
            components.removeValue(forKey: "J")
            let key = components.sorted(by: { $0.value > $1.value }).first!.key
            components[key] = components[key]! + jokerCount
        }
        
        let sortedCounts = components.values.sorted()
        
        switch sortedCounts {
            case [5]: return .fiveOfAKind
            case [1,4]: return .fourOfAKind
            case [2,3]: return .fullHouse
            case [1,1,3]: return .threeOfAKind
            case [1,2,2]: return .twoPair
            case [1,1,1,2]: return .onePair
            default: return .highCard
        }
    }
}
