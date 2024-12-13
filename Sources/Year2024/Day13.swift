import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let games = parse(input)
        var results = 0
        
        for game in games {
            results += solve(game, adjusted: false)
        }
        
        return results
    }
    
    public func part2(_ input: [String]) -> Int {
        let games = parse(input)
        var results = 0
        
        for game in games {
            results += solve(game, adjusted: true)
        }
        
        return results
    }
    
    public func part2b(_ input: [String]) -> Int {
        let games = parse(input)
        var results = 0
        
        for game in games {
            results += solve3(game, adjusted: true)
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
    
    struct Best: Hashable {
        let score: Int
        let t1: Int
        let t2: Int
        let cost: Int
        let dx: Int
    }
    
    // Based on Jonathan Paulson's Python solution
    func solve3(_ game: Game, adjusted: Bool) -> Int {
        let p2 = adjusted ? 10000000000000 : 0
        var best: Best?
        
        // calculate the shortest most cost effective trajectory as close to an angle of 45 degrees as possible for as far as possible, but leaving wiggle room to brute force the shortest path at the end
        for t1 in (0..<600) {
            for t2 in (0..<600) {
                let cost = 3 * t1 + t2
                let dx = game.a.x * t1 + game.b.x * t2
                let dy = game.a.y * t1 + game.b.y * t2
                
                if dx > 0, dx == dy {
                    let score = dx / cost
                    if best == nil || score < best!.score {
                        best = Best(score: score, t1: t1, t2: t2, cost: cost, dx: dx)
                    }
                }
            }
        }
        
        guard let best else { return 0 }
        
        let amt = (p2 - 40000) / best.dx
        var cache = [Point: Int]()
        
        func findMinimumCost(to point: Point) -> Int {
            if let result = cache[point] {
                return result
            } else if point == .zero {
                return 0
            } else if point.x < 0 {
                return 1000000000000000000
            } else if point.y < 0 {
                return 1000000000000000000
            }
            
            let ans = min(3 + findMinimumCost(to: Point(point.x - game.a.x, point.y - game.a.y)), 1 + findMinimumCost(to: Point(point.x - game.b.x, point.y - game.b.y)))
            cache[point] = ans
            return ans
        }
        
        let ans = findMinimumCost(to: Point(game.prize.x + p2 - amt * best.dx, game.prize.y + p2 - amt * best.dx))
        if ans < pow(10, 15) {
            return ans + amt * best.cost
        } else {
            return 0
        }
    }
    
    func solve(_ game: Game, adjusted: Bool) -> Int {
        // prioritise button `b` because it's cheaper to push
        let valueX = adjusted ? game.prize.x + 10000000000000 : game.prize.x
        let valueY = adjusted ? game.prize.y + 10000000000000 : game.prize.y
        let maxPushes = valueX / game.b.x + 1
        
        for i in (0..<maxPushes).reversed() {
            if (valueX - (game.b.x * i)) % game.a.x == 0 {
                let option = Option(a: (valueX - (game.b.x * i)) / game.a.x, b: i)
                if game.b.y * i + game.a.y * option.a == valueY {
                    return option.a * 3 + option.b
                }
            }
        }
        
        
        return 0
    }
//    
//    func solve2(_ game: Game, adjusted: Bool) -> Int {
//        let a = solve(game.prize.x, a: game.a.x, b: game.b.x, adjusted: adjusted)
//        if a.isEmpty { return 0 }
//        
//        let b = solve(game.prize.y, a: game.a.y, b: game.b.y, adjusted: adjusted)
//        if b.isEmpty { return 0 }
//        
//        for option in a.reversed() {
//            if b.contains(option) {
//                return option.a * 3 + option.b
//            }
//        }
//        
//        return 0
//    }
//    
//    func solve(_ value: Int, a: Int, b: Int, adjusted: Bool) -> [Option] {
//        // prioritise button `b` because it's cheaper to push
//        let value = adjusted ? value + 10000000000000 : value
//        var options = [Option]()
//        let maxPushes = value / b + 1
//        
//        for i in 0..<maxPushes {
//            if (value - (b * i)) % a == 0 {
//                let option = Option(a: (value - (b * i)) / a, b: i)
//                options.append(option)
//            }
//        }
//        
//        return options
//    }
}
