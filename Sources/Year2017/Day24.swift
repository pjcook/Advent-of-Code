//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day24 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let ports = Set(input.map {
            $0.split(separator: "/").map(String.init).compactMap(Int.init).sorted()
        })
        
        var strongest = 0
        let queue = PriorityQueue<Bridge>()
        var seen = Set<Bridge>()
        for port in ports where port[0] == 0 {
            queue.enqueue(Bridge(list: [port], end: port.last!), priority: 1)
        }
        
        while !queue.isEmpty {
            let bridge = queue.dequeue()!
            guard !seen.contains(bridge) else { continue }
            seen.insert(bridge)
            if bridge.strength > strongest {
                strongest = bridge.strength
                print(strongest, queue.queuedItems.count, bridge.list.count)
            }
            
            let next = ports.filter {
                !bridge.list.contains($0) && ( $0.first == bridge.end || $0.last == bridge.end)
            }
            for n in next {
                queue.enqueue(Bridge(list: bridge.list + [n], end: n.first(where: { $0 != bridge.end }) ?? n.last!), priority: strongest - bridge.strength)
            }
        }
        
        return strongest
    }
    
    public func part2(_ input: [String]) -> Int {
        let ports = Set(input.map {
            $0.split(separator: "/").map(String.init).compactMap(Int.init).sorted()
        })
        
        var longest = 0
        var longestStrongestBridge: Bridge?
        let queue = PriorityQueue<Bridge>()
        var seen = Set<Bridge>()
        for port in ports where port[0] == 0 {
            queue.enqueue(Bridge(list: [port], end: port.last!), priority: 1)
        }
        
        while !queue.isEmpty {
            let bridge = queue.dequeue()!
            guard !seen.contains(bridge) else { continue }
            seen.insert(bridge)
            if bridge.list.count > longest || (bridge.list.count == longest && longestStrongestBridge?.strength ?? 0 < bridge.strength) {
                longestStrongestBridge = bridge
                longest = bridge.list.count
                print(longest, queue.queuedItems.count, bridge.strength, longestStrongestBridge?.strength ?? -1)
            }
            
            let next = ports.filter {
                !bridge.list.contains($0) && ( $0.first == bridge.end || $0.last == bridge.end)
            }
            for n in next {
                queue.enqueue(Bridge(list: bridge.list + [n], end: n.first(where: { $0 != bridge.end }) ?? n.last!), priority: -bridge.list.count)
            }
        }
        
        return longestStrongestBridge?.strength ?? -1
    }
    
    struct Bridge: Hashable {
        let list: [[Int]]
        let end: Int
        let strength: Int
        
        init(list: [[Int]], end: Int) {
            self.list = list
            self.end = end
            self.strength = list.reduce([Int](), +).reduce(0, +)
        }
        
        init(list: [[Int]], end: Int, score: Int) {
            self.list = list
            self.end = end
            self.strength = score
        }
    }
}
