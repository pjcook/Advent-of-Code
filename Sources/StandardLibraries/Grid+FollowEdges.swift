//
//  File.swift
//  AdventOfCode
//
//  Created by PJ on 12/12/2024.
//

import Foundation

/// Given a starting tile and direction, follow the edge of the given area (`tiles`) and return the list of tiles that touch that outer edge. `changedDirection` is called every time the edge goes in a different direction
public func followEdge(from point: Point, with initialDirection: Direction, tiles: [Point], changedDirection: (() -> Void)?) -> Set<Point> {
    var position = point
    var direction: Direction = initialDirection
    var edges = Set<Point>()
    while true {
        edges.insert(position)
        if canContinue(from: position, in: direction, plots: tiles) {
            position = position + direction.point
            
            // Exit when back at start
            if position == point, direction == initialDirection {
                break
            }
            continue
        }
        
        changedDirection?()
        changeDirection(from: &position, in: &direction, plots: tiles)
        
        // Exit when back at start
        if position == point, direction == initialDirection {
            break
        }
    }
    
    return edges
}

private func canContinue(from point: Point, in direction: Direction, plots: [Point]) -> Bool {
    let next = point + direction.point
    return plots.contains(next) && !plots.contains(next + direction.emptyEdge.point)
}

private func changeDirection(from point: inout Point, in direction: inout Direction, plots: [Point]) {
    let next = point + direction.point
    
    if plots.contains(next + direction.emptyEdge.point) {
        point = next + direction.emptyEdge.point
        direction = direction.emptyEdge
    } else {
        direction = direction.emptyEdge.opposite
    }
}
