//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day23 {
    let elf = "#"
    let emptyGround = "."
    
    public init() {}
    
    public func part1(_ input: [String], numberOfRounds: Int) -> Int {
        var elves = parse(input)
        var turns: [CompassDirection] = [.n, .s, .w, .e]
        let turnPositions: [CompassDirection: [Position]] = [
            .n: [.tl, .t, .tr],
            .s: [.bl, .b, .br],
            .e: [.tr, .r, .br],
            .w: [.tl, .l, .bl]
        ]
        let directionMap: [CompassDirection: Position] = [
            .n: .t,
            .s: .b,
            .e: .r,
            .w: .l
        ]
        var proposedMoves = [Point: [Point]]()
        var elvesToIgnore = Set<Point>()
        
        // check and create proposed moves for elf
        @discardableResult func check(direction: CompassDirection, e: Point) -> Point? {
            var check = Set<Point>()
            for position in turnPositions[direction]! {
                check.insert(e + position.point)
            }
            if check.intersection(elves).count == 0 {
                let proposedMove = e + directionMap[direction]!.point
                var suggestion = proposedMoves[proposedMove, default: []]
                suggestion.append(e)
                proposedMoves[proposedMove] = suggestion
                if suggestion.count > 1 {
                    elvesToIgnore = elvesToIgnore.union(suggestion)
                }
                return proposedMove
            }
            
            return nil
        }
        
        roundsLoop: for _ in (0..<numberOfRounds) {
            // propose moves for elves
            for e in elves {
                let neighbours = e.neighbors(true)
                guard elves.intersection(neighbours).count > 0 else { continue }
                
                for turn in turns {
                    if check(direction: turn, e: e) != nil {
                        break
                    }
                }
            }
        
//            if proposedMoves.isEmpty {
//                break roundsLoop
//            }
            
            // move elves that can move
            var nextElves = elves
            for e in Set(proposedMoves.filter({ $0.value.count == 1 }).values.compactMap({ $0.first })).subtracting(elvesToIgnore) {
                for turn in turns {
                    if let point = check(direction: turn, e: e) {
                        nextElves.remove(e)
                        nextElves.insert(point)
                        break
                    }
                }
            }
            let minMax = nextElves.minMax()
            elves = Set(nextElves.map { $0 - minMax.0 })
            
//            let columns = minMax.1.x - minMax.0.x + 1
//            let rows = minMax.1.y - minMax.0.y + 1
//            var grid = Grid(columns: columns, items: Array(repeating: emptyGround, count: columns * rows))
//            for e in elves {
//                grid[e] = elf
//            }
//            grid.draw()
//            print()
            
            // cycle turn order
            let turn = turns.removeFirst()
            turns.append(turn)
            
            // Reset lists
            proposedMoves = [:]
            elvesToIgnore = []
        }
        
        let minMax = elves.minMax()
        let columns = minMax.1.x - minMax.0.x + 1
        let rows = minMax.1.y - minMax.0.y + 1
        return columns * rows - elves.count
    }
    
    public func part2(_ input: [String]) -> Int {
        var elves = parse(input)
        var turns: [CompassDirection] = [.n, .s, .w, .e]
        let turnPositions: [CompassDirection: [Position]] = [
            .n: [.tl, .t, .tr],
            .s: [.bl, .b, .br],
            .e: [.tr, .r, .br],
            .w: [.tl, .l, .bl]
        ]
        let directionMap: [CompassDirection: Position] = [
            .n: .t,
            .s: .b,
            .e: .r,
            .w: .l
        ]
        var proposedMoves = [Point: [Point]]()
        var elvesToIgnore = Set<Point>()
        
        // check and create proposed moves for elf
        @discardableResult func check(direction: CompassDirection, e: Point) -> Point? {
            var check = Set<Point>()
            for position in turnPositions[direction]! {
                check.insert(e + position.point)
            }
            if check.intersection(elves).count == 0 {
                let proposedMove = e + directionMap[direction]!.point
                var suggestion = proposedMoves[proposedMove, default: []]
                suggestion.append(e)
                proposedMoves[proposedMove] = suggestion
                if suggestion.count > 1 {
                    elvesToIgnore = elvesToIgnore.union(suggestion)
                }
                return proposedMove
            }
            
            return nil
        }
        var round = 0
        roundsLoop: while true {
            round += 1
            // propose moves for elves
            for e in elves {
                let neighbours = e.neighbors(true)
                guard elves.intersection(neighbours).count > 0 else { continue }
                
                for turn in turns {
                    if check(direction: turn, e: e) != nil {
                        break
                    }
                }
            }
        
            if proposedMoves.isEmpty {
                break roundsLoop
            }
            
            // move elves that can move
            var nextElves = elves
            for e in Set(proposedMoves.filter({ $0.value.count == 1 }).values.compactMap({ $0.first })).subtracting(elvesToIgnore) {
                for turn in turns {
                    if let point = check(direction: turn, e: e) {
                        nextElves.remove(e)
                        nextElves.insert(point)
                        break
                    }
                }
            }
            let minMax = nextElves.minMax()
            elves = Set(nextElves.map { $0 - minMax.0 })
            
            // cycle turn order
            let turn = turns.removeFirst()
            turns.append(turn)
            
            // Reset lists
            proposedMoves = [:]
            elvesToIgnore = []
        }
        
        return round
    }
}

extension Day23 {
    public func parse(_ input: [String]) -> Set<Point> {
        var elves = Set<Point>()
        
        for y in (0..<input.count) {
            let line = input[y]
            for x in (0..<line.count) {
                if String(line[x]) == elf {
                    elves.insert(Point(x,y))
                }
            }
        }
        
        return elves
    }
}
