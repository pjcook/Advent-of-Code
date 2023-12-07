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
        
        init(cards: String, bid: Int, handType: WinningHandType) {
            self.cards = cards
            self.bid = bid
            self.handType = handType
        }
    }
    
    public func part1(_ input: [String]) -> Int {
        let hands = parse(input, calculateWinningHandType: calculateWinningHandTypePart1).sorted(by: <)
        var sum = 0
        for (index, hand) in hands.enumerated() {
            let rank = index + 1
            sum += hand.bid * rank
        }
        return sum
    }
    
    func calculateWinningHandTypePart1(from cards: String) -> Day7.WinningHandType {
        var components = [Character:Int]()
        for card in cards {
            components[card] = components[card, default: 0] + 1
        }
        
        if components.count == 1 {
            return .fiveOfAKind
        } else if components.count == 2 {
            if [1,4].contains(components.first!.value) {
                return .fourOfAKind
            } else {
                return .fullHouse
            }
        } else if components.count == 3 {
            for value in components.values {
                if value == 3 {
                    return .threeOfAKind
                }
            }
            return .twoPair
        } else if components.count == 4 {
            return .onePair
        } else {
            return .highCard
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        let hands = parse(input, calculateWinningHandType: calculateWinningHandTypePart2).sorted(by: sortPart2)
        var sum = 0
        for (index, hand) in hands.enumerated() {
            let rank = index + 1
            sum += hand.bid * rank
        }
        return sum
    }
    
    func calculateWinningHandTypePart2(from cards: String) -> Day7.WinningHandType {
        var components = [Character:Int]()
        for card in cards {
            components[card] = components[card, default: 0] + 1
        }
        
        if components.count > 1, let jokerCount = components["J"] {
            components.removeValue(forKey: "J")
            let key = components.sorted(by: { $0.value > $1.value }).first!.key
            components[key] = components[key]! + jokerCount
        }
        
        if components.count == 1 {
            return .fiveOfAKind
        } else if components.count == 2 {
            if [1,4].contains(components.first!.value) {
                return .fourOfAKind
            } else {
                return .fullHouse
            }
        } else if components.count == 3 {
            for value in components.values {
                if value == 3 {
                    return .threeOfAKind
                }
            }
            return .twoPair
        } else if components.count == 4 {
            return .onePair
        } else {
            return .highCard
        }
    }
    
    func sortPart2(lhs: Hand, rhs: Hand) -> Bool {
        if lhs.handType == rhs.handType {
            for i in (0..<lhs.cards.count) {
                let lhsCardStrength = cardStrengthPart2[String(lhs.cards[i]), default: 0]
                let rhsCardStrength = cardStrengthPart2[String(rhs.cards[i]), default: 0]
                
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

extension Day7.Hand {
    static func < (lhs: Day7.Hand, rhs: Day7.Hand) -> Bool {
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
    
    static let cardStrength = [
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
}

extension Day7 {
    func parse(_ input: [String], calculateWinningHandType: (String) -> Day7.WinningHandType) -> [Hand] {
        var hands = [Hand]()
        
        for line in input {
            let components = line.components(separatedBy: " ")
            let handType = calculateWinningHandType(components[0])
            let hand = Hand(cards: components[0], bid: Int(String(components[1]))!, handType: handType)
            hands.append(hand)
        }
        
        return hands
    }
}
