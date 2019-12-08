//
//  Day4Tests.swift
//  Year2018Tests
//
//  Created by PJ COOK on 06/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2018

class Day4Tests: XCTestCase {

    func test_reposeLineData() throws {
        let input = [
            "[1518-11-01 00:00] Guard #10 begins shift",
            "[1518-11-01 00:05] falls asleep",
            "[1518-11-01 00:25] wakes up",
            "[1518-11-01 00:30] falls asleep",
            "[1518-11-01 00:55] wakes up",
            "[1518-11-01 23:58] Guard #99 begins shift",
            "[1518-11-02 00:40] falls asleep",
            "[1518-11-02 00:50] wakes up",
            "[1518-11-03 00:05] Guard #10 begins shift",
            "[1518-11-03 00:24] falls asleep",
            "[1518-11-03 00:29] wakes up",
            "[1518-11-04 00:02] Guard #99 begins shift",
            "[1518-11-04 00:36] falls asleep",
            "[1518-11-04 00:46] wakes up",
            "[1518-11-05 00:03] Guard #99 begins shift",
            "[1518-11-05 00:45] falls asleep",
            "[1518-11-05 00:55] wakes up"
        ]
        
        var data = [ReposeLineData]()
        for item in input {
            data.append(try ReposeLineData(item))
        }
        
        XCTAssertEqual(input.count, data.count)
        XCTAssertEqual(ReposeLineData.LineDataType.asleep, data[1].dataType)
        XCTAssertEqual(ReposeLineData.LineDataType.awake, data[7].dataType)
        switch data[5].dataType {
        case .asleep, .awake: XCTFail()
        case let .beginShift(id):
            XCTAssertEqual(99, id)
        }
    }
    
    func test_part1() {
        
    }

}
