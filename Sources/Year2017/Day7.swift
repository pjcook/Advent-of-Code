//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation

public struct Day7 {
    public init() {}
    
    public func part1(_ input: [String]) -> String {
        let listings = parse(input)
        let results = listings.filter { !$0.children.isEmpty }
        return results.first {
            let id = $0.id
            return results.filter({ $0.id != id }).first {
                $0.children.contains(id)
            } == nil
        }!.id
    }
    
    public func part2(_ input: [String], rootID: String) -> Int {
        let listings = parse(input)
        let nodes = makeNodes(from: listings)
        return nodes[rootID]!.balance()
    }
    
    struct Listing {
        let id: String
        let value: Int
        let children: [String]
    }
    
    final class Node {
        let id: String
        let value: Int
        var children: [Node]
        var score: Int = 0
        
        init(id: String, value: Int, children: [Node]) {
            self.id = id
            self.value = value
            self.children = children
        }
        
        func balance(depth: Int = 1) -> Int {
            for c in children {
                let result = c.balance(depth: depth + 1)
                if result != 0 {
                    return result
                }
            }
            
            if children.count > 0 {
                let value = children[0].score
                for c in children {
                    if c.score != value {
                        let dx = max(c.score, value) - min(c.score, value)
                        if value > c.score {
                            return children[0].value - dx
                        } else {
                            return c.value - dx
                        }
                    }
                }
            }
            
            score = children.reduce(value) { $0 + $1.score }
            return 0
        }
    }
}

extension Day7 {
    func parse(_ input: [String]) -> [Listing] {
        var results = [Listing]()
        
        for line in input {
            let parts = line
                .replacingOccurrences(of: " -> ", with: " ")
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .replacingOccurrences(of: ",", with: "")
                .split(separator: " ")
                .map(String.init)
            results.append(Listing(id: parts[0], value: Int(parts[1])!, children: Array(parts[2...])))
        }
        
        return results
    }
    
    func makeNodes(from listings: [Listing]) -> [String: Node] {
        var nodes: [String: Node] = [:]
        var queue: [Listing] = listings
        
        while queue.count > 0 {
            let listing = queue.removeFirst()
            let node = nodes[listing.id, default: Node(id: listing.id, value: listing.value, children: [])]
            if node.children.count == listing.children.count {
                nodes[listing.id] = node
                continue
            }
            var children = [Node]()
            for nodeID in listing.children {
                if let n = nodes[nodeID] {
                    children.append(n)
                }
            }
            node.children = children
            nodes[listing.id] = node
            if node.children.count != listing.children.count {
                queue.append(listing)
            }
        }
        
        return nodes
    }
}
