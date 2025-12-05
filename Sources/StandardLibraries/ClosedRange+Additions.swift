//
//  File.swift
//  AdventOfCode
//
//  Created by PJ on 05/12/2025.
//

import Foundation

extension [ClosedRange<Int>] {
    mutating public func compress(with range: ClosedRange<Int>) {
        var overlaps: [ClosedRange<Int>] = []
        var indexesToRemove: [Int] = []

        for i in 0..<count {
            let a = self[i]
            if a.overlaps(range) {
                indexesToRemove.append(i)
                overlaps.append(a)
            }
        }

        for i in indexesToRemove.reversed() {
            self.remove(at: i)
        }

        let range2 = overlaps.reduce(range) { Swift.min($0.lowerBound, $1.lowerBound)...Swift.max($0.upperBound, $1.upperBound) }
        self.append(range2)
    }

    mutating public func compress() {
        guard !isEmpty else { return }
        forEach { compress(with: $0) }
    }
}
