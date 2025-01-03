//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let programs = parse(input)
        var queue = [[Int]]()
        queue.append([0])
        var results = Set<Int>()
        
        while queue.isEmpty == false {
            let list = queue.removeFirst()
            guard let children = programs[list.last!] else { continue }
            let remaining = children.filter { !list.contains($0) }
            guard remaining.isEmpty == false else {
                for item in list {
                    results.insert(item)
                }
                continue
            }
            
            for c in remaining {
                queue.append(list + [c])
            }
        }
        
        return results.count
    }
    
    public func part2(_ input: [String]) -> Int {
        let programs = parse(input)
        var ids = Array(programs.keys)
        var count = 0
        while ids.isEmpty == false {
            let id = ids.removeFirst()
            let nodes = findNodes(from: id, programs: programs)
            if !nodes.isEmpty {
                count += 1
            }
            for n in nodes {
                if let index = ids.firstIndex(of: n) {
                    ids.remove(at: index)
                }
            }
        }
        
        return count
    }
}

extension Day12 {
    func findNodes(from: Int, programs: [Int:[Int]]) -> Set<Int> {
        var queue = [[Int]]()
        queue.append([from])
        var results = Set<Int>()
        
        while queue.isEmpty == false {
            let list = queue.removeFirst()
            guard let children = programs[list.last!] else { continue }
            let remaining = children.filter { !list.contains($0) }
            guard remaining.isEmpty == false else {
                for item in list {
                    results.insert(item)
                }
                continue
            }
            
            for c in remaining {
                queue.append(list + [c])
            }
        }
        
        return results
    }
    
    func parse(_ input: [String]) -> [Int:[Int]] {
        var results = [Int:[Int]]()
        
        for line in input {
            let parts = line
                .replacingOccurrences(of: " <-> ", with: ",")
                .replacingOccurrences(of: ", ", with: ",")
                .split(separator: ",")
                .map(String.init)
                .compactMap(Int.init)
            results[parts[0]] = Array(parts[1...])
        }
        
        return results
    }
}
