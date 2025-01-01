//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Algorithms
import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    public func part1(_ input: [String], shouldReturn: Bool) -> Int {
        let grid = Grid<String>(input)
        let start = grid.point(for: "0")!
        let pointsToReach = (0...9).compactMap({ grid.point(for: "\($0)") })
        var distances = [[Point]: Int]()
        for p1 in pointsToReach {
            for p2 in pointsToReach {
                guard p1 != p2, distances[[p1, p2]] == nil else { continue }
                let distance = grid.dijkstra(start: p1, end: p2, calculateScore: { _ in 1}, canEnter: { grid[$0] != "#" })
                distances[[p1, p2]] = distance
                distances[[p2, p1]] = distance
            }
        }
        
        var smallest = Int.max
        for x in pointsToReach.permutations() where x.first! == start {
            var distance = 0
            for i in 1..<x.count {
                distance += distances[[x[i - 1], x[i]]]!
            }
            if shouldReturn {
                distance += distances[[x.last!, start]]!
            }
            smallest = min(distance, smallest)
        }
        
        return smallest
    }
}
