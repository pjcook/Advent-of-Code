import Foundation
import StandardLibraries

public struct Day12 {
    public init() {}
    public typealias Elements = [String:[String]]
    
    /*
     Your goal is to find the number of distinct paths that start at start, end at end, and don't visit small caves more than once. There are two types of caves: big caves (written in uppercase, like A) and small caves (written in lowercase, like b). It would be a waste of time to visit any small cave more than once, but big caves are large enough that it might be worth visiting them multiple times. So, all paths you find should visit small caves at most once, and can visit big caves any number of times.
     */
    public func part1(_ input: [String]) -> Int {
        // parse the input
        let elements = parse(input)
        var paths = Set<String>()
        // find the paths
        findPath("start", visited: ["start"], cannotRevisit: ["start"], elements: elements, foundPaths: &paths, allowRepeatSmall: false)
        return paths.count
    }
    
    /*
     After reviewing the available paths, you realize you might have time to visit a single small cave twice. Specifically, big caves can be visited any number of times, a single small cave can be visited at most twice, and the remaining small caves can be visited at most once. However, the caves named start and end can only be visited exactly once each: once you leave the start cave, you may not return to it, and once you reach the end cave, the path must end immediately.
     */
    public func part2(_ input: [String]) -> Int {
        // parse the input
        let elements = parse(input)
        var paths = Set<String>()
        // find the paths
        findPath("start", visited: ["start"], cannotRevisit: ["start"], elements: elements, foundPaths: &paths, allowRepeatSmall: true)
        return paths.count
    }
    
    public func findPath(_ current: String, visited: [String], cannotRevisit: Set<String>, elements: Elements, foundPaths: inout Set<String>, allowRepeatSmall: Bool) {
        // get destination options for current cave
        let options = elements[current]
        
        var remainingOptions = options
        
        // if not allowed to revisit
        if !allowRepeatSmall {
            remainingOptions = options?.filter {
                !cannotRevisit.contains($0)
            }
        }
        
        // filter out any visited lowercase caves
        guard let remainingOptions = remainingOptions else { return }
        
        // plot paths to any remaining caves
        for dest in remainingOptions {
            if dest == "end" {
                // Finished, save path
                var newVisited = visited
                newVisited.append(dest)
                let path = newVisited.joined(separator: ",")
                foundPaths.insert(path)
            } else if dest == "start" {
                // ignore
            } else {
                // keep following path
                var allowRepeat = allowRepeatSmall
                var newVisited = visited
                newVisited.append(dest)
                var newCannotRevisit = cannotRevisit
                if dest == dest.lowercased() {
                    if cannotRevisit.contains(dest) {
                        allowRepeat = false
                    }
                    newCannotRevisit.insert(dest)
                }
                
                findPath(dest, visited: newVisited, cannotRevisit: newCannotRevisit, elements: elements, foundPaths: &foundPaths, allowRepeatSmall: allowRepeat)
            }
        }
    }
    
    public func solution2(_ input: [String], allowRepeat: Bool = false) -> Int {
        // parse the input
        let elements = parse(input)
        var paths = [[String]]()
        // find the paths
        findPath2(visited: ["start"], cannotRevisit: ["start"], elements: elements, foundPaths: &paths, hasVisitedSmallCaveTwice: !allowRepeat)
        return paths.count
    }
    
    public func findPath2(visited: [String], cannotRevisit: Set<String>, elements: Elements, foundPaths: inout [[String]], hasVisitedSmallCaveTwice: Bool) {
        // plot paths to any remaining caves
        for dest in elements[visited.last!]! {
            if dest == "end" {
                // Finished, save path
                var newVisited = visited
                newVisited.append(dest)
                foundPaths.append(newVisited)
            } else if dest == "start" {
                // ignore
            } else if hasVisitedSmallCaveTwice && cannotRevisit.contains(dest) {
                // ignore
            } else {
                // keep following path
                var seen = hasVisitedSmallCaveTwice
                var newVisited = visited
                newVisited.append(dest)
                var newCannotRevisit = cannotRevisit
                if dest == dest.lowercased() {
                    if cannotRevisit.contains(dest) {
                        seen = true
                    }
                    newCannotRevisit.insert(dest)
                }
                
                findPath2(visited: newVisited, cannotRevisit: newCannotRevisit, elements: elements, foundPaths: &foundPaths, hasVisitedSmallCaveTwice: seen)
            }
        }
    }
    
    public func parse(_ input: [String]) -> Elements {
        var connections = Elements()
        for instruction in input {
            let split = instruction.split(separator: "-")
            connections[String(split[0]), default: []].append(String(split[1]))
            connections[String(split[1]), default: []].append(String(split[0]))
        }
        return connections
    }
    
    // Apparently using item.components(separatedBy: "-") is like 10x slower than the above!!!
    public func parse_slow(_ input: [String]) -> Elements {
        var nodes = Elements()
        // sepearate each line into 2 parts
        for item in input {
            let split = item.components(separatedBy: "-")
            // map both parts each way round
            nodes[split[0], default: []].append(split[1])
            nodes[split[1], default: []].append(split[0])
        }
        return nodes
    }
}
