//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day13 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let nodes = input.map(Node.init)
        var severity = 0
        
        for node in nodes {
            guard node.position > 0 else {
                severity += node.position * node.length
                continue
            }
            
            var pointer = 0
            var dx = 1
            for _ in 0..<node.position {
                pointer += dx
                if pointer == 0 {
                    dx = 1
                } else if pointer == node.length-1 {
                    dx = -1
                }
            }
            if pointer == 0 {
                severity += node.position * node.length
            }
        }
        
        return severity
    }
    
    final class NodeWrapper {
        let node: Node
        var pointer = 0
        var dx = 1
        
        init(_ node: Node) {
            self.node = node
            for _ in 0..<node.position {
                pointer += dx
                if pointer == 0 {
                    dx = 1
                } else if pointer == node.length-1 {
                    dx = -1
                }
            }
        }
        
        func tick() {
            pointer += dx
            if pointer == 0 {
                dx = 1
            } else if pointer == node.length-1 {
                dx = -1
            }
        }
    }
    
    public func part2(_ input: [String]) -> Int {
        let nodes = input.map(Node.init).map(NodeWrapper.init)
        var delay = 1
        
        while true {
            var failed = false
            
            for node in nodes {
                node.tick()
                if node.pointer == 0 {
                    failed = true
                }
            }
            if failed == false {
                break
            }
            delay += 1
        }
        
        return delay
    }
    
    struct Node {
        let position: Int
        let length: Int
        
        init(_ value: String) {
            let parts = value.split(separator: ": ").map(String.init).compactMap(Int.init)
            position = parts[0]
            length = parts[1]
        }
    }
}
