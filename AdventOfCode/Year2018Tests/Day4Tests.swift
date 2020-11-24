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
        data.sort { $0.date < $1.date }
        
        XCTAssertEqual(input.count, data.count)
        XCTAssertEqual(ReposeLineData.LineDataType.asleep, data[1].dataType)
        XCTAssertEqual(ReposeLineData.LineDataType.awake, data[7].dataType)
        switch data[5].dataType {
        case .asleep, .awake: XCTFail()
        case let .beginShift(id):
            XCTAssertEqual(99, id)
        }
    }
    
    func test_part1() throws {
        let input = try readInput(filename: "Day4.input", delimiter: "\n", cast: String.init, bundle: Year2018.bundle)
        
        var data = [ReposeLineData]()
        for item in input {
            data.append(try ReposeLineData(item))
        }
        data.sort { $0.date < $1.date }
        var guards = [Int: Guard]()
//        data.map { print("\($0)") }
        
        var guardItem: ReposeLineData!
        while !data.isEmpty {
            let item = data.removeFirst()
            var asleepItem = item
            var awakeItem = item
            switch item.dataType {
            case .beginShift:
                guardItem = item
                if case .beginShift = data.first!.dataType {
                    continue
                }
                asleepItem = data.removeFirst()
                awakeItem = data.removeFirst()
            case .asleep:
                awakeItem = data.removeFirst()
            case .awake:
                assertionFailure()
            }
            
            let id = guardItem.dataType.id
            assert(id != -1)
//            print(id, "\(guardItem)", "\(asleepItem)", "\(awakeItem)")
            let sleepTime = SleepTime(start: asleepItem.date, end: awakeItem.date)
            if var g = guards[id] {
                g.sleepTimes.append(sleepTime)
                guards[id] = g
            } else {
                let g = Guard(id: id, sleepTimes: [sleepTime])
                guards[id] = g
            }
        }
        
//        guards.map { print("\($0)") }
        var g = guards.values.first!
        for gu in guards.values {
            if gu.totalSleep > g.totalSleep {
                g = gu
            }
        }
        
//        print(g.id, g.sleepiestMinute, g.id * g.sleepiestMinute)
        XCTAssertEqual(g.id * g.sleepiestMinute.0, 39422)
    }
    
    func test_part2() throws {
        let input = try readInput(filename: "Day4.input", delimiter: "\n", cast: String.init, bundle: Year2018.bundle)
        
        var data = [ReposeLineData]()
        for item in input {
            data.append(try ReposeLineData(item))
        }
        data.sort { $0.date < $1.date }
        var guards = [Int: Guard]()
        var guardItem: ReposeLineData!
        while !data.isEmpty {
            let item = data.removeFirst()
            var asleepItem = item
            var awakeItem = item
            switch item.dataType {
            case .beginShift:
                guardItem = item
                if case .beginShift = data.first!.dataType {
                    continue
                }
                asleepItem = data.removeFirst()
                awakeItem = data.removeFirst()
            case .asleep:
                awakeItem = data.removeFirst()
            case .awake:
                assertionFailure()
            }
            
            let id = guardItem.dataType.id
            assert(id != -1)

            let sleepTime = SleepTime(start: asleepItem.date, end: awakeItem.date)
            if var g = guards[id] {
                g.sleepTimes.append(sleepTime)
                guards[id] = g
            } else {
                let g = Guard(id: id, sleepTimes: [sleepTime])
                guards[id] = g
            }
        }
        
        var g = guards.values.first!
        for gu in guards.values {
            if gu.sleepiestMinute.1 > g.sleepiestMinute.1 {
                g = gu
            }
        }
        
        XCTAssertEqual(g.id * g.sleepiestMinute.0, 65474)
    }
}
