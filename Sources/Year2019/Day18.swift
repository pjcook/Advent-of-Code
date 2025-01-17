//
//  Day18.swift
//  Year2019
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import Foundation
import StandardLibraries

public struct Day18 {
    public init() {}
    
    typealias Graph = [GraphKey2: Int]
    struct GraphKey2: Hashable {
        let points: [Point]
        let keys: Int
        init(_ points: [Point], _ keys: [String]) {
            self.points = points.sorted()
            self.keys = Array(Set(keys)).sorted().reduce(0) { $0 | String($1).letterIndexOf() }
        }
    }
    
    public func part1c(_ input: [String]) -> Int {
        var grid = Grid<String>(input)
        let symbols = grid.items.filter { Alphabet.letters.lowercased().contains($0) }.sorted()
        let start = grid.point(for: "@")!
        grid[start] = "."
        
        var keys = Set<Symbol>()
        for symbol in symbols {
            let point = grid.point(for: symbol)!
            keys.insert(Symbol(symbol: symbol, point: point))
            grid[point] = "."
        }
        
        var graph = Graph()
        return minimumSteps(from: [start], seen: &graph, allKeys: keys, grid: grid)
    }
    
    func minimumSteps(from: Set<Point>, haveKeys: [String] = [], seen: inout Graph, allKeys: Set<Symbol>, grid: Grid<String>) -> Int {
        let key = GraphKey2(Array(from), haveKeys)
        if let value = seen[key] {
            return value
        }
        
        let answer = findKeys(in: grid, from: from, keys: allKeys.filter({ !haveKeys.contains($0.symbol) }), emptyBlocks: haveKeys.map({ $0.uppercased() }) + ["."])
            .map { (symbol, cost) in
                cost + minimumSteps(from: [symbol.point], haveKeys: haveKeys + [symbol.symbol], seen: &seen, allKeys: allKeys, grid: grid)
            }.min() ?? 0
        seen[key] = answer
        return answer
    }
    
    public func part1b(_ input: [String]) -> Int {
        var grid = Grid<String>(input)
        let symbols = grid.items.filter { Alphabet.letters.lowercased().contains($0) }.sorted()
        var shortest = Int.max
        let start = grid.point(for: "@")!
        grid[start] = "."
        
        var keys = Set<Symbol>()
        var doors = Set<Symbol>()
        for symbol in symbols {
            let point = grid.point(for: symbol)!
            keys.insert(Symbol(symbol: symbol, point: point))
            grid[point] = "."
            if let point = grid.point(for: symbol.uppercased()) {
                doors.insert(Symbol(symbol: symbol.uppercased(), point: point))
            }
        }
        
        var graph = [GraphKey: ([(Symbol, Int)], Int)]()
//        return calculateShortestPath(start: start, allKeys: keys, grid: grid)
        
        let queue = PriorityQueue<QueueItem2>()
        queue.enqueue(QueueItem2(keys: [], point: start, costSoFar: 0), priority: 0)
        
        var found = 0
        
        var i = 0
        while let item = queue.dequeue() {
            i += 1
            if i % 10000 == 0 {
                found += 1
                print(i, queue.queuedItems.count, graph.count, item.keys.count, item.costSoFar, shortest, found)
            }
            guard item.costSoFar < shortest else { continue }
            if item.keys.count == keys.count {
                found = 0
                shortest = min(shortest, item.costSoFar)
                print("Shortest", i, queue.queuedItems.count, graph.count, item.keys.count, item.costSoFar, shortest, item.keys.joined(separator: ","))
                continue
            }
            
            if found == 10 {
                return shortest
            }
            
            let graphKey = GraphKey(item)
            var routes: [(Day18.Symbol, Int)]
            if let (cachedRoutes, cost) = graph[graphKey] {
                guard cost > item.costSoFar else { continue }
                routes = cachedRoutes
            } else {
                routes = findKeys(in: grid, from: item.point, keys: keys.filter({ !item.keys.contains($0.symbol) }), emptyBlocks: item.keys.map({ $0.uppercased() }) + ["."])
            }
            graph[graphKey] = (routes, item.costSoFar)
            for (route, routeCost) in routes {
                guard !item.keys.contains(route.symbol) else { continue }
                let newKeys = Array(item.keys + [route.symbol])
                let cost = routeCost + item.costSoFar
                queue.enqueue(
                    QueueItem2(
                        keys: newKeys,
                        point: route.point,
                        costSoFar: cost
                    ),
                    priority: -newKeys.count// - cost
                )
            }
        }
        
        return shortest
    }
    
    func calculateShortestPath(start: Point, allKeys: Set<Symbol>, grid: Grid<String>) -> Int {
        var smallest = Int.max
        var graph = [GraphKey: ([(Symbol, Int)], Int)]()
        let queue = PriorityQueue<QueueItem2>()
        queue.enqueue(QueueItem2(keys: [], point: start, costSoFar: 0), priority: 0)
        var i = 0
        while let item = queue.dequeue() {
            i += 1
            if item.keys.count == 26 {
                smallest = min(smallest, item.costSoFar)
                print("smallest", smallest, item.costSoFar, queue.queuedItems.count, i, graph.count)
                continue
            }
            
            let key = GraphKey(item.point, item.keys)
            let cachedItem = graph[key]
            guard cachedItem == nil || item.costSoFar < cachedItem?.1 ?? Int.max else { continue }
            let options = cachedItem?.0 ?? findKeys(in: grid, from: item.point, keys: allKeys.filter({ !item.keys.contains($0.symbol) }), emptyBlocks: item.keys.map({ $0.uppercased() }) + ["."])
            graph[key] = (options, item.costSoFar)
            for option in options {
                let cost = item.costSoFar + option.1
                let newKeys = item.keys + [option.0.symbol]
                let next = option.0.point
                guard cost < smallest else { continue }
                queue.enqueue(QueueItem2(keys: newKeys, point: next, costSoFar: cost), priority: -cost)
            }
        }
        
        return smallest
    }
    
    func findKeys(in grid: Grid<String>, from: Set<Point>, keys: Set<Symbol>, emptyBlocks: [String]) -> [(Symbol, Int)] {
        var symbols: [(Symbol, Int)] = []
        
        for point in from {
            symbols.append(contentsOf: findKeys(in: grid, from: point, keys: keys, emptyBlocks: emptyBlocks))
        }
        
        return symbols
    }
    
    func findKeys(in grid: Grid<String>, from: Point, keys: Set<Symbol>, emptyBlocks: [String]) -> [(Symbol, Int)] {
        var symbols: [(Symbol, Int)] = []
        var seen = Set<Point>()
        var queue = [(Point, Int)]()
        queue.append((from, 0))
        
        while !queue.isEmpty {
            let (point, cost) = queue.removeFirst()
            if let s = keys.first(where: { point == $0.point }) {
                symbols.append((s, cost))
            }
            
            // exit early if possible, probably unlikely
            if symbols.count == keys.count {
                break
            }
            
            for n in point.cardinalNeighbors(in: grid, matching: emptyBlocks) {
                if !seen.contains(n) {
                    seen.insert(n)
                    queue.append((n, cost + 1))
                }
            }
        }
        
        return symbols
    }
    
    struct QueueItem2: Hashable {
        let keys: [String]
        let point: Point
        let costSoFar: Int
    }
    
    struct GraphValue: Hashable {
        let symbol: Symbol
        let cost: Int
        let keysOnRoute: [Symbol]
    }
    
    struct GraphKey: Hashable {
        let point: Point
        let keys: Int
        init(_ point: Point, _ keys: [String]) {
            self.point = point
            self.keys = Array(Set(keys)).sorted().reduce(0) { $0 | String($1).letterIndexOf() }
        }
        init(_ item: QueueItem2) {
            self.point = item.point
            self.keys = Array(Set(item.keys)).sorted().reduce(0) { $0 | String($1).letterIndexOf() }
        }
    }
    
    public func part1(_ input: [String], filename: String) -> Int {
        let grid = Grid<String>(input)
        let symbols = grid.items.filter { Alphabet.letters.lowercased().contains($0) }.sorted()
        let allSymbols = ["@", "."] + symbols + symbols.map { $0.uppercased() }
        let start = grid.point(for: "@")!
        var keys = Set<Symbol>()
        var doors = Set<Symbol>()
        for symbol in symbols {
            keys.insert(Symbol(symbol: symbol, point: grid.point(for: symbol)!))
            if let point = grid.point(for: symbol.uppercased()) {
                doors.insert(Symbol(symbol: symbol.uppercased(), point: point))
            }
        }
        let doorsAndKeys = keys.union(doors)
        let doorKeyPoints = doorsAndKeys.map({ $0.point })
        let doorkeyMap = doorsAndKeys.reduce(into: [:]) { $0[$1.point] = $1 }
        var distances: [DistanceKey: DistanceValue] = [:]
        
        if let data = try? Data(contentsOf: resolveFilename(filename), options: .uncached) {
            if let cachedData = try? JSONDecoder().decode([DistanceKey: DistanceValue].self, from: data) {
                distances = cachedData
            }
        }
        
        if distances.isEmpty {
            for from in Set(keys + [Symbol(symbol: "@", point: start)]) {
                for to in keys where to != from {
                    let key = DistanceKey(from: from.point, to: to.point)
                    guard distances[key] == nil else { continue }
                    let route = grid.routeTo(start: from.point, end: to.point, emptyBlocks: allSymbols)
                    let locationsOnRoute = Set(Set(route.dropLast()).intersection(doorKeyPoints)
                        .compactMap { doorkeyMap[$0]! })
                    let distanceValue = DistanceValue(symbols: locationsOnRoute, distance: route.count)
                    distances[key] = distanceValue
                    distances[DistanceKey(from: to.point, to: from.point)] = distanceValue
                }
            }
            
            writeCache(distances, filename: filename)
        }
        
        //        return plotPath(from: start, history: [], keys: keys, doors: doors, distances: distances)
        
        let queue = PriorityQueue<QueueItem>()
        queue.enqueue(QueueItem(keysFound: [], doorsOpened: [], from: start, to: start, costSoFar: 0, history: []), priority: 0)
        
        var shortest = Int.max
        var seen = [String: Int]()
        
        var i = 0
        var found = 0
        while let item = queue.dequeue() {
            i += 1
            if i % 100000 == 0 {
                found += 1
                print("ping:", shortest, queue.queuedItems.count, seen.count, item.keysFound.count, item.doorsOpened.count, item.costSoFar, item.historyPath, found)
            }
            guard item.costSoFar < shortest else { continue }
            
            if item.keysFound.count == keys.count {
                shortest = min(shortest, item.costSoFar)
                print("shortest path:", shortest, queue.queuedItems.count, seen.count, item.keysFound.count, item.doorsOpened.count, item.historyPath, found)
                found = 0
                seen.filter { $0.value > shortest }.forEach { seen.removeValue(forKey: $0.key) }
                continue
            }
            
            let options = nextOptions(distances: distances, keys: keys, doors: doors, queueItem: item)
            //            options.map { s in ( keys.first { $0.point == s.to }!.symbol, distances[DistanceKey(from: item.to, to: s.to)]!.distance) }.map { print($0) }
            for option in options {
                guard option.costSoFar < shortest, seen[option.seenKey, default: Int.max] > option.costSoFar else { continue }
                seen[option.seenKey] = option.costSoFar
                queue.enqueue(option, priority: -option.costSoFar)
            }
        }
        
        return shortest
    }
    
    public func part2(_ input: [String]) -> Int {
        1
    }
    
    struct Symbol: Hashable, Codable {
        let symbol: String
        let point: Point
    }
    
    struct DistanceKey: Hashable, Codable {
        let from: Point
        let to: Point
    }
    
    struct DistanceValue: Hashable, Codable {
        let symbols: Set<Symbol>
        let distance: Int
    }
    
    struct QueueItem: Hashable {
        let keysFound: Set<Symbol>
        let doorsOpened: Set<Symbol>
        let from: Point
        let to: Point
        let costSoFar: Int
        let history: [Symbol]
        
        var seenKey: String {
            history.map({ $0.symbol }).joined()
        }
        
        var historyPath: String {
            history.map({ $0.symbol }).joined(separator: ",")
        }
    }
    
    struct BasicQueueItem: Hashable {
        let point: Point
        let keys: Set<Symbol>
        let cost: Int
        let history: String
    }
}

extension String {
    func letterIndexOf() -> Int {
        switch self {
        case "a": 0b00000000000000000000000001
        case "b": 0b00000000000000000000000010
        case "c": 0b00000000000000000000000100
        case "d": 0b00000000000000000000001000
        case "e": 0b00000000000000000000010000
        case "f": 0b00000000000000000000100000
        case "g": 0b00000000000000000001000000
        case "h": 0b00000000000000000010000000
        case "i": 0b00000000000000000100000000
        case "j": 0b00000000000000001000000000
        case "k": 0b00000000000000010000000000
        case "l": 0b00000000000000100000000000
        case "m": 0b00000000000001000000000000
        case "n": 0b00000000000010000000000000
        case "o": 0b00000000000100000000000000
        case "p": 0b00000000001000000000000000
        case "q": 0b00000000010000000000000000
        case "r": 0b00000000100000000000000000
        case "s": 0b00000001000000000000000000
        case "t": 0b00000010000000000000000000
        case "u": 0b00000100000000000000000000
        case "v": 0b00001000000000000000000000
        case "w": 0b00010000000000000000000000
        case "x": 0b00100000000000000000000000
        case "y": 0b01000000000000000000000000
        case "z": 0b10000000000000000000000000
        default: fatalError("unknown:\(self)")
        }
    }
}

extension Day18 {
    func plotPath(from: Point, history: [Symbol], keys: Set<Symbol>, doors: Set<Symbol>, distances: [DistanceKey: DistanceValue]) -> Int {
        let queue = PriorityQueue<BasicQueueItem>()
        queue.enqueue(BasicQueueItem(point: from, keys: [], cost: 0, history: ""), priority: 0)
        var shortest = Int.max
        var i = 0
        var seen = [String: Int]()
        
        while let next = queue.dequeue() {
            i += 1
            if i % 10000 == 0 {
                print(i, shortest, queue.queuedItems.count, seen.count, next.keys.count, next.cost, next.history)
            }
            guard next.cost < shortest else { continue }
            if next.keys.count == keys.count {
                shortest = min(shortest, next.cost)
                seen.filter { $0.value >= shortest }.forEach { seen.removeValue(forKey: $0.key) }
                continue
            }
            let keySymbols = next.keys.map { $0.symbol.uppercased() }
            let lockedDoors = doors.filter { !(keySymbols).contains($0.symbol) }
            for key in keys.subtracting(next.keys) {
                guard let path = distances[DistanceKey(from: next.point, to: key.point)],
                      lockedDoors.isEmpty || path.symbols.intersection(lockedDoors).isEmpty,
                      next.cost + path.distance < shortest
                else { continue }
                let newKeys = next.keys.union([key]).union(path.symbols.intersection(keys))
                let history = next.history + (path.symbols.subtracting(next.keys).subtracting(doors) + [key]).map({ $0.symbol }).joined()
                let cost = next.cost + path.distance
                let cacheKey = String(history.sorted())
                guard seen[cacheKey, default: Int.max] > cost else { continue }
                seen[cacheKey] = cost
                let priority = i % 4 == 0 ? -cost : -newKeys.count
                queue.enqueue(BasicQueueItem(point: key.point, keys: newKeys, cost: cost, history: history), priority: priority)
            }
        }
        
        return shortest
    }
    
    func nextOptions(distances: [DistanceKey: DistanceValue], keys: Set<Symbol>, doors: Set<Symbol>, queueItem: QueueItem) -> [QueueItem] {
        var options = Set<QueueItem>()
        let keySymbols = queueItem.keysFound.map { $0.symbol.uppercased() }
        let lockedDoors = doors.filter { !(keySymbols).contains($0.symbol) }
        for to in keys.subtracting(queueItem.keysFound) {
            guard let path = distances[DistanceKey(from: queueItem.to, to: to.point)],
                  lockedDoors.isEmpty || path.symbols.intersection(lockedDoors).isEmpty
            else { continue }
            let fullPath = path.symbols.union([to])
            let newCost = queueItem.costSoFar + path.distance
            let newKeys = queueItem.keysFound.union(fullPath.intersection(keys))
            let newDoors = queueItem.doorsOpened.union(fullPath.intersection(doors))
            options.insert(QueueItem(keysFound: newKeys, doorsOpened: newDoors, from: queueItem.to, to: to.point, costSoFar: newCost, history: queueItem.history + path.symbols.subtracting(queueItem.keysFound).subtracting(queueItem.doorsOpened).subtracting(doors) + [to]))
        }
        return Array(options)
    }
    
    func resolveFilename(_ filename: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    }
    
    func writeCache(_ distances: [DistanceKey: DistanceValue], filename: String) {
        let url = resolveFilename(filename)
        do {
            let data = try JSONEncoder().encode(distances)
            try data.write(to: url)
            print(url)
        } catch { print(error) }
    }
}
