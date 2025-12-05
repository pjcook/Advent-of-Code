//
//  ClosedRangeTests.swift
//  StandardLibrariesTests
//
//  Created by PJ on 12/12/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import StandardLibraries
class ClosedRangeTests: XCTestCase {
    func test_compress_ClosedRanges() {
        var ranges = [
            3...5,
            10...14,
            16...20,
            12...18,
        ]
        ranges.compress()
        XCTAssertEqual(2, ranges.count)
    }

    func test_compressWith_ClosedRanges() {
        var ranges = [
            3...5,
            16...20,
            12...18,
        ]
        ranges.compress(with: 10...14)
        XCTAssertEqual(3, ranges.count)
    }
}
