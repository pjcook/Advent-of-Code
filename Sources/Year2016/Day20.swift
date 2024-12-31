//
//
//  File.swift
//  
//
//  Created by PJ on 26/11/2022.
//

import Foundation
import StandardLibraries

public struct Day20 {
    public init() {}
    
    public func part1(_ input: [String]) -> Int {
        let sortedRanges = reduce(ranges: parse(input)).sorted(by: { $0.lowerBound < $1.lowerBound })
        var i = 0
        var value = 0
        while i < sortedRanges.count {
            let range = sortedRanges[i]
            if range.contains(value) {
                value = range.upperBound + 1
            } else {
                return value
            }
            i += 1
        }
                
        return value
    }
    
    public func part2(_ input: [String]) -> Int {
        4294967295 - reduce(ranges: parse(input)).reduce(0) { $0 + ($1.upperBound - $1.lowerBound) + 1 } + 1
    }
}

extension Day20 {
    func parse(_ input: [String]) -> [ClosedRange<Int>] {
        var ranges = [ClosedRange<Int>]()
        
        for line in input {
            let values = line.split(separator: "-").map { Int($0)! }
            let range = values.first!...values.last!
            ranges.append(range)
        }
        
        return ranges
    }
    
    func reduce(ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var ranges = Set(ranges)
        var results = Set<ClosedRange<Int>>()
        
        while ranges.isEmpty == false {
            let range = ranges.removeFirst()
            var overlapped = false
            for r in ranges {
                if r.overlaps(range) {
                    ranges.remove(r)
                    
                    let newRange = min(r.lowerBound, range.lowerBound)...max(r.upperBound, range.upperBound)
                    ranges.insert(newRange)
                    overlapped = true
                }
            }
            if !overlapped {
                results.insert(range)
            }
        }
        
        return Array(results)
    }
}
