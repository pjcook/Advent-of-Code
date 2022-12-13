//
//  File.swift
//  
//
//  Created by PJ on 13/12/2022.
//

import Foundation

public struct Day13 {
    public init() {}
    
    public func part1(_ input: [String]) throws -> Int {
        let pairs = input.split(separator: "")
        var count = 0

        for (index, pair) in pairs.enumerated() {
            let line1 = try parse(pair.first!)
            let line2 = try parse(pair.last!)
            if process(list1: line1, list2: line2) == .rightOrder {
                count += (index + 1)
            }
        }
        
        return count
    }
    
    public func part2(_ input: [String]) throws -> Int {
        var lines: [[Any]] = input.compactMap { line in
            guard !line.isEmpty else { return nil }
            return try! parse(line)
        }
        
        let divider1: [[Any]] = [[2]]
        let divider2: [[Any]] = [[6]]
        lines.append(divider1)
        lines.append(divider2)
        
        lines.sort { list1, list2 in
            process(list1: list1, list2: list2) == .rightOrder
        }
        
        let index1 = lines.firstIndex(where: { $0.description == divider1.description })! + 1
        let index2 = lines.firstIndex(where: { $0.description == divider2.description })! + 1

        return index1 * index2
    }
}

extension Day13 {
    public func process(list1: [Any], list2: [Any]) -> CompareResult {
        for (item1, item2) in zip(list1, list2) {
            if let item1 = item1 as? Int, let item2 = item2 as? Int {
                if item1 < item2 { return .rightOrder }
                else if item1 > item2 { return .wrongOrder }
            } else if let item1 = item1 as? [Any], let item2 = item2 as? [Any] {
                let result = process(list1: item1, list2: item2)
                guard result != .sameOrder else { continue }
                return result
            } else if let item1 = item1 as? Int, let item2 = item2 as? [Any] {
                let result = process(list1: [item1], list2: item2)
                guard result != .sameOrder else { continue }
                return result
            } else if let item1 = item1 as? [Any], let item2 = item2 as? Int {
                let result = process(list1: item1, list2: [item2])
                guard result != .sameOrder else { continue }
                return result
            }
        }
        
        if list1.count < list2.count { return .rightOrder }
        else if list1.count > list2.count { return .wrongOrder }
        return .sameOrder
    }
    
    public func parse(_ line: String) throws -> [Any] {
        try JSONSerialization.jsonObject(with: line.data(using: .utf8)!, options: .fragmentsAllowed) as! [Any]
    }
}

extension Day13 {
    public enum CompareResult {
        case rightOrder
        case wrongOrder
        case sameOrder
    }
}
