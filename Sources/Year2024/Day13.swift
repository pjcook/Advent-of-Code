import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let games = parse(input)
        var results = 0
        
        for game in games {
            let result = solve(game, adjusted: false)
            print(result)
            results += result
        }
        
        return results
    }
    
    public func part2(_ input: [String]) -> Int {
        let games = parse(input)
        var results = 0
        
        for game in games {
            let result = solve(game, adjusted: true)
            print(result)
            results += result
        }
        
        return results
    }
    
    struct Game: Hashable {
        let a: Point
        let b: Point
        let prize: Point
    }
    
    struct Option: Hashable {
        let a: Int
        let b: Int
    }
}

extension Day13 {
    func parse(_ input: [String]) -> [Game] {
        var input = input
        var games = [Game]()
        
        while !input.isEmpty {
            let a = input.removeFirst().replacingOccurrences(of: "Button A: X+", with: "").replacingOccurrences(of: " Y+", with: "").components(separatedBy: ",").map { Int($0)! }
            let b = input.removeFirst().replacingOccurrences(of: "Button B: X+", with: "").replacingOccurrences(of: " Y+", with: "").components(separatedBy: ",").map { Int($0)! }
            let prize = input.removeFirst().replacingOccurrences(of: "Prize: X=", with: "").replacingOccurrences(of: " Y=", with: "").components(separatedBy: ",").map { Int($0)! }
            
            let game = Game(a: Point(a[0], a[1]), b: Point(b[0], b[1]), prize: Point(prize[0], prize[1]))
            games.append(game)
            
            if !input.isEmpty {
                input.removeFirst()
            }
        }
        
        return games
    }
    
    func solve(_ game: Game, adjusted: Bool) -> Int {
        let a = solve(game.prize.x, a: game.a.x, b: game.b.x, adjusted: adjusted)
        if a.isEmpty { return 0 }
        
        let b = solve(game.prize.y, a: game.a.y, b: game.b.y, adjusted: adjusted)
        if b.isEmpty { return 0 }
        
        for option in a.reversed() {
            if b.contains(option) {
                return option.a * 3 + option.b
            }
        }
        
        return 0
    }
    
    func solve(_ value: Int, a: Int, b: Int, adjusted: Bool) -> [Option] {
        // prioritise button `b` because it's cheaper to push
        let value = adjusted ? value + 10000000000000 : value
        var options = [Option]()
        let maxPushes = max(value / b, 100)
        
        for i in 0..<maxPushes {
            if i % 1000 == 0 {
                print(i, options.count)
            }
            if (value - (b * i)) % a == 0 {
                let option = Option(a: (value - (b * i)) / a, b: i)
                options.append(option)
            }
        }
        
        return options
    }
}
