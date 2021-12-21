import Foundation
import StandardLibraries

public class Day21 {
    public init() {}
    
    public func part1(_ game: Board) -> Int {
        game.play()
        if game.player1.score < game.player2.score {
            return game.player1.score * game.dice.rollCount
        }
        return game.player2.score * game.dice.rollCount
    }

    public func part1_condensed(_ game: Game) -> Int {
        var p1Position = game.p1
        var p1Score = 0
        var p2Position = game.p2
        var p2Score = 0
        var i = 0
        while p1Score < 1000 && p2Score < 1000 {
            if i % 2 == 0 {
                var position = p1Position + ((6 + 9 * i) % 10)
                if position > 10 {
                    position = max(position % 10, 1)
                }
                p1Score += position
                p1Position = position
            } else {
                var position = p2Position + ((6 + 9 * i) % 10)
                if position > 10 {
                    position = max(position % 10, 1)
                }
                p2Score += position
                p2Position = position
            }
            i += 1
        }
        return 3 * i * min(p2Score, p1Score)
    }
    
    public func part1_jonathanPoulson(_ game: Game) -> Int {
        var die = 0
        func roll() -> Int {
            die += 1
            return die
        }
        
        var p1 = game.p1-1
        var p2 = game.p2-1
        var s1 = 0
        var s2 = 0
        while true {
            let m1 = roll() + roll() + roll()
            p1 = (p1 + m1) % 10
            s1 += p1 + 1
            if s1 >= 1000 { break }
            
            let m2 = roll() + roll() + roll()
            p2 = (p2 + m2) % 10
            s2 += p2 + 1
            if s2 >= 1000 { break }
        }
        
        var answer = s2 * die
        if s1 < s2 {
            answer = s1 * die
        }
        return answer
    }
    // Game state for memoization
    var gameState = [Game: (Int,Int)]()

    public struct Game: Hashable {
        public let p1: Int
        public let p2: Int
        public let s1: Int
        public let s2: Int
        public init(_ p1: Int, _ p2: Int, _ s1: Int = 0, _ s2: Int = 0) {
            self.p1 = p1
            self.p2 = p2
            self.s1 = s1
            self.s2 = s2
        }
    }
    
    public func part2_jonathanPoulson(_ game: Game) -> Int {
        let ans = countWin(Game(game.p1-1, game.p2-1))
        return max(ans.0, ans.1)
    }
    
    /*
     Brute force with momoization
     */
    private func countWin(_ game: Game) -> (Int,Int) {
        // Given that A is at game.p1 with score game.s1 and B is at game.p2 with score game.s2
        // return (# of universes where player A wins, # of universes where player B wins)
        if game.s1 >= 21 {
            return (1,0)
        }
        if game.s2 >= 21 {
            return (0,1)
        }
        if let answer = gameState[game] {
            return answer
        }
        var answer = (0,0)
        for d1 in [1,2,3] {
            for d2 in [1,2,3] {
                for d3 in [1,2,3] {
                    let new_p1 = (game.p1 + d1 + d2 + d3) % 10
                    let new_s1 = game.s1 + new_p1 + 1
                    let (a,b) = countWin(Game(game.p2, new_p1, game.s2, new_s1))
                    answer = (answer.0 + b, answer.1 + a)
                }
            }
        }
        gameState[game] = answer
        return answer
    }
    
    // Fancy version of part 1
    public class Player {
        public let id: Int
        public var score = 0
        public var position: Int
        
        public init(id: Int, startingAt: Int) {
            self.id = id
            self.position = startingAt
        }
        
        public func clone() -> Player {
            let player = Player(id: id, startingAt: position)
            player.score = score
            return player
        }
    }
    
    public class Dice {
        public let sides: Int
        public var value = 0
        public var rollCount = 0
        public init(_ sides: Int = 3, value: Int = 0){
            self.sides = sides
            self.value = value
        }
        public func roll() -> Int {
            rollCount += 1
            return value
        }
    }
    
    public class DeterministicDice: Dice {
        public override func roll() -> Int {
            value += 1
            rollCount += 1
            if value > sides { value = 1 }
            return value
        }
    }
    
    public class Board {
        public let player1: Player
        public let player2: Player
        public let dice: Dice
        private var player1Active = true
        private let maxScore: Int
        public init(dice: Dice, player1StartingAt: Int, player2StartingAt: Int, maxScore: Int = 1000) {
            self.maxScore = maxScore
            self.dice = dice
            self.player1 = Day21.Player(id: 1, startingAt: player1StartingAt)
            self.player2 = Day21.Player(id: 2, startingAt: player2StartingAt)
        }
        
        public func play() {
            while !isWon {
                takeTurn()
            }
        }
        
        private func takeTurn() {
            player1Active ? move(player1) : move(player2)
            player1Active = !player1Active
        }
        
        private func move(_ player: Player) {
            let m = dice.roll() + dice.roll() + dice.roll()
            player.position += m % 10
            if player.position > 10 {
                player.position = max((player.position % 10), 1)
            }
            player.score += player.position
//            print(player.id, m, player.position, player.score)
        }
        
        private var isWon: Bool {
            player1.score >= maxScore || player2.score > maxScore
        }
    }
}
