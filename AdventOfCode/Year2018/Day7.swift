//
//  Day7.swift
//  Year2018
//
//  Created by PJ on 09/12/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public struct Day7 {
    
    public class Node {
        let id: Character
        var parents: Set<Node> = []
        var children: Set<Node> = []
        var isComplete = false
        var canProcess: Bool {
            return parents.isEmpty || parents.reduce(true) { $0 && $1.isComplete }
        }
        var stepsToComplete: Int = 0
        
        public init(id: Character, addTime: Bool) {
            self.id = id
            if addTime {
                stepsToComplete = (Alphabet.lettersUppercasedList.firstIndex(of: id) ?? -1) + 1
            }
        }
        
        func sortedChildren() -> [Node] {
            children.sorted(by: { $0.id < $1.id })
        }
    }
    
    let regex = try! RegularExpression(pattern: #"^Step ([A-Z]{1}) must be finished before step ([A-Z]{1}) can begin."#)
    
    public func parse(_ input: [String]) throws -> [(Character, Character)] {
        try input
            .map { try regex.match($0) }
            .map { (try $0.character(at: 0), try $0.character(at: 1))}
    }
    
    public func graph(_ input: [(Character, Character)], addTime: Bool = false) -> Set<Node> {
        var nodes = [Character: Node]()
        var input = input
        while !input.isEmpty {
            let pair = input.removeFirst()
            let node = nodes[pair.0] ?? Node(id: pair.0, addTime: addTime)
            let child = nodes[pair.1] ?? Node(id: pair.1, addTime: addTime)
            node.children.insert(child)
            child.parents.insert(node)
            nodes[node.id] = node
            nodes[child.id] = child
        }
        
        return Set(nodes.values)
    }
    
    public func part1(_ input: Set<Node>) -> String {
        var nodes = input
        var output = ""
        while !nodes.isEmpty {
            var available = nodes.sorted(by: { $0.id < $1.id }).filter({ $0.canProcess })
            let node = available.removeFirst()
            node.isComplete = true
            nodes.remove(at: nodes.firstIndex(of: node)!)
            output += String(node.id)
            
        }
        return output
    }
    
    public func part2(_ input: Set<Node>, numberOfWorkers: Int = 5, stepDuration: Int = 60) -> Int {
        var nodes = input
        var steps = 0
        var workInProgress = Set<Node>()
        
        while !nodes.isEmpty || !workInProgress.isEmpty {
            // increment steps
            steps += 1

            // set new work
            var available = nodes.sorted(by: { $0.id < $1.id }).filter({ $0.canProcess && !workInProgress.contains($0) })

            while workInProgress.count < numberOfWorkers && !available.isEmpty {
                let node = available.removeFirst()
                node.stepsToComplete += stepDuration
                nodes.remove(at: nodes.firstIndex(of: node)!)
                workInProgress.insert(node)
            }

            // process work
            for work in workInProgress {
                work.stepsToComplete -= 1
                if work.stepsToComplete <= 0 {
                    work.isComplete = true
                    workInProgress.remove(work)
                }
            }

        }
        return steps
    }
}

extension Day7.Node: Hashable {
    public static func == (lhs: Day7.Node, rhs: Day7.Node) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
