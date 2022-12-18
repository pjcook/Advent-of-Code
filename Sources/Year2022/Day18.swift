//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day18 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        calculateSurfaceArea(Set(parse(input)))
    }
    
    public func part2(_ input: [String]) -> Int {
        let vectors = Set(parse(input))
        let (minVector, maxVector) = vectors.minMax()
        var edges = Set<Vector>()
        
        // create edge list
        for y in (minVector.y...maxVector.y) {
            for x in (minVector.x...maxVector.x) {
                let vector = Vector(x: x, y: y, z: minVector.z)
                edges.insert(vector)
            }
        }

        for y in (minVector.y...maxVector.y) {
            for x in (minVector.x...maxVector.x) {
                let vector = Vector(x: x, y: y, z: maxVector.z)
                edges.insert(vector)
            }
        }

        for z in (minVector.z...maxVector.z) {
            for x in (minVector.x...maxVector.x) {
                let vector = Vector(x: x, y: minVector.y, z: z)
                edges.insert(vector)
            }
        }
        
        for z in (minVector.z...maxVector.z) {
            for x in (minVector.x...maxVector.x) {
                let vector = Vector(x: x, y: maxVector.y, z: z)
                edges.insert(vector)
            }
        }
        
        for z in (minVector.z...maxVector.z) {
            for y in (minVector.y...maxVector.y) {
                let vector = Vector(x: minVector.x, y: y, z: z)
                edges.insert(vector)
            }
        }
        
        for z in (minVector.z...maxVector.z) {
            for y in (minVector.y...maxVector.y) {
                let vector = Vector(x: maxVector.x, y: y, z: z)
                edges.insert(vector)
            }
        }
        
        // remove known lava
        edges = edges.subtracting(vectors)
        
        // calculate outsideEdges
        var outsideEdges = Set<Vector>()
        while let edge = edges.popFirst() {
            outsideEdges.insert(edge)
            var queue = Set<Vector>()
            queue.insert(edge)
            while let item = queue.popFirst() {
                var edgesToTry = item.cardinalNeighbours(max: maxVector)
                edgesToTry = edgesToTry.subtracting(vectors)
                edgesToTry = edgesToTry.subtracting(outsideEdges)
                edgesToTry = edgesToTry.subtracting(queue)
                outsideEdges = outsideEdges.union(edgesToTry)
                queue = queue.union(edgesToTry)
            }
        }
        
        // Create whole cube
        var cube = Set<Vector>()
        for z in (minVector.z...maxVector.z) {
            for y in (minVector.y...maxVector.y) {
                for x in (minVector.x...maxVector.x) {
                    cube.insert(Vector(x: x, y: y, z: z))
                }
            }
        }
        
        // Remove outsideEdges
        cube = cube.subtracting(outsideEdges)
        
        // Calculate surface
        return calculateSurfaceArea(cube)
    }
    
    func calculateSurfaceArea(_ vectors: Set<Vector>) -> Int {
        var count = 0
        for vector in vectors {
            var adjacentCount = 0
            for adjacent in vector.cardinalNeighbours() {
                if vectors.contains(adjacent) {
                    adjacentCount += 1
                }
            }
            count += 6 - adjacentCount
        }
        return count
    }
}

extension Day18 {
    public func parse(_ input: [String]) -> [Vector] {
        var results = [Vector]()
        
        for line in input {
            let components = line.components(separatedBy: ",")
            let vector = Vector(x: Int(components[0])!, y: Int(components[1])!, z: Int(components[2])!)
            results.append(vector)
        }
        
        return results
    }
}
