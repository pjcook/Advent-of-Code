import Foundation
import StandardLibraries

public struct Day22 {
    public init() {}
        
    public func part1(_ input: [String]) -> Int {
        let (player1, player2) = parse(input)
        let cardCount = player1.cards.count + player2.cards.count
        var turns = 0
        
        while !gameOver(cardCount, player: player1) {
            turns += 1
            let card1 = player1.draw()
            let card2 = player2.draw()
            if card1 > card2 {
                player1.won(input: [card1, card2])
            } else {
                player2.won(input: [card2, card1])
            }
        }
        let winner = player1.cards.count == cardCount ? player1 : player2
        return calculateScore(winner: winner, cardCount: cardCount)
    }
    
    public func part2(_ input: [String]) -> Int {
        let (player1, player2) = parse(input)
        let cardCount = player1.cards.count + player2.cards.count
        let winner = playRecursiveCombat(player1: player1, player2: player2, cardCount: cardCount)
        return calculateScore(winner: winner, cardCount: cardCount)
    }
}

public extension Day22 {
    func playRecursiveCombat(player1: Player, player2: Player, cardCount: Int) -> Player {
        var turns = 0
        
        while !gameOver(cardCount, player: player1) {
            turns += 1
            
            guard !player1.alreadyPlayedHand() && !player2.alreadyPlayedHand() else {
                return player1
            }
            player1.saveHand()
            player2.saveHand()
            let card1 = player1.draw()
            let card2 = player2.draw()
            
            if player1.cards.count >= card1 && player2.cards.count >= card2 {
                let winner = playRecursiveCombat(player1: player1.miniMi(card1), player2: player2.miniMi(card2), cardCount: card1 + card2)
                if winner.name == player1.name {
                    player1.won(input: [card1, card2])
                } else {
                    player2.won(input: [card2, card1])
                }
            } else {
                if card1 > card2 {
                    player1.won(input: [card1, card2])
                } else {
                    player2.won(input: [card2, card1])
                }
            }
        }
        
        return player1.cards.count == cardCount ? player1 : player2
    }
    
    func gameOver(_ max: Int, player: Player) -> Bool {
        return player.cards.count == 0 || player.cards.count == max
    }
    
    func calculateScore(winner: Player, cardCount: Int) -> Int {
        var total = 0
        
        for (index, value) in winner.cards.reversed().enumerated() {
            total += ((index + 1) * value)
        }
        
        return total
    }
}

public extension Day22 {
    func parse(_ input: [String]) -> (Player, Player) {
        var players = [Player]()
        var cards = [Int]()
        var name = ""
        for line in input {
            if line.hasPrefix("Player") {
                name = line
            } else if let card = Int(line) {
                cards.append(card)
            } else {
                players.append(Player(name: name, cards: cards))
                name = ""
                cards = []
            }
        }
        if !cards.isEmpty {
            players.append(Player(name: name, cards: cards))
        }
        return (players[0], players[1])
    }
}

public extension Day22 {
    class Player {
        public let name: String
        public var cards: [Int]
        public var hands: Set<String> = []
        
        public init(name: String, cards: [Int]) {
            self.name = name
            self.cards = cards
        }
        
        public func draw() -> Int {
            cards.removeFirst()
        }
        
        public func won(input: [Int]) {
            cards += input
        }
        
        public func hand() -> String {
            cards.map { String($0) }.joined()
        }
        
        public func alreadyPlayedHand() -> Bool {
            return hands.contains(hand())
        }
        
        public func miniMi(_ cardCount: Int) -> Player {
            Player(name: name, cards: Array(cards[0..<cardCount]))
        }
        
        public func saveHand() {
            hands.insert(hand())
        }
    }
}
