//
//  Day5Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 05/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day5Tests: XCTestCase {

    func test_sample_data1() throws {
        let data = "1101,100,-1,4,0".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        let output = computer.process({ 0 })
        XCTAssertEqual(-1, output)
        XCTAssertEqual(99, computer.readData[4])
    }
    
    func test_sample_data1b() throws {
        let data = "1101,100,-1,4,0".split(separator: ",").compactMap { Int($0) }
        var output = 0
        let computer = SteppedIntComputer(
            id: 1,
            data: data,
            readInput: { 0 },
            processOutput: { output = $0 },
            completionHandler: {},
            forceWriteMode: true
        )
        computer.process()
        while computer.state == .running {
            continue
        }
        
        XCTAssertEqual(0, output)
    }
    
    func test_part1_chris() throws {
        guard let data = try readInput(filename: "Day5_sample1.input", delimiter: ",", cast: Int.init, bundle: Bundle(for: Day5Tests.self)) as? [Int] else { return XCTFail() }
        let computer = AdvancedIntCodeComputer(data: data)
        let output = computer.process({ 5 })
        XCTAssertEqual(584126, output)
    }
    
    func test_part1_steppedIntComputer() throws {
        guard let data = try readInput(filename: "Day5_sample1.input", delimiter: ",", cast: Int.init, bundle: Bundle(for: Day5Tests.self)) as? [Int] else { return XCTFail() }
        var output = 0
        let computer = SteppedIntComputer(
            id: 1,
            data: data,
            readInput: { 5 },
            processOutput: { output = $0 },
            completionHandler: {},
            forceWriteMode: true
        )
        computer.process()
        while computer.state == .running {
            continue
        }
        XCTAssertEqual(584126, output)
    }
    
    func test_part1() throws {
        guard let data = try readInput(filename: "Day5.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { return XCTFail() }
        let computer = AdvancedIntCodeComputer(data: data)
        let output = computer.process({ 1 })
        XCTAssertEqual(9006673, output)
    }
    
    func test_part2_sample_data1() throws {
        let data = "3,9,8,9,10,9,4,9,99,-1,8".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(1, computer.process({ 8 }))
    }
    
    func test_part2_sample_data1b() throws {
        let data = "3,9,8,9,10,9,4,9,99,-1,8".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(0, computer.process({ 7 }))
    }
    
    func test_part2_sample_data2() throws {
        let data = "3,9,7,9,10,9,4,9,99,-1,8".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(1, computer.process({ 7 }))
    }
    
    func test_part2_sample_data2b() throws {
        let data = "3,9,7,9,10,9,4,9,99,-1,8".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(0, computer.process({ 8 }))
    }
    
    func test_part2_sample_data3() throws {
        let data = "3,3,1108,-1,8,3,4,3,99".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(1, computer.process({ 8 }))
    }
    
    func test_part2_sample_data3b() throws {
        let data = "3,3,1108,-1,8,3,4,3,99".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(0, computer.process({ 9 }))
    }
    
    func test_part2_sample_data4() throws {
        let data = "3,3,1107,-1,8,3,4,3,99".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(1, computer.process({ 6 }))
    }
    
    func test_part2_sample_data4b() throws {
        let data = "3,3,1107,-1,8,3,4,3,99".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(0, computer.process({ 9 }))
    }
    
    func test_part2_sample_data5() throws {
        let data = "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(0, computer.process({ 0 }))
    }
    
    func test_part2_sample_data5b() throws {
        let data = "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(1, computer.process({ 99 }))
    }
    
    func test_part2_sample_data6() throws {
        let data = "3,3,1105,-1,9,1101,0,0,12,4,12,99,1".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(0, computer.process({ 0 }))
    }
    
    func test_part2_sample_data6b() throws {
        let data = "3,3,1105,-1,9,1101,0,0,12,4,12,99,1".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(1, computer.process({ 9 }))
    }
    
    func test_part2_sample_data7() throws {
        let data = "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99".split(separator: ",").compactMap { Int($0) }
        let computer = AdvancedIntCodeComputer(data: data)
        XCTAssertEqual(999, computer.process({ 6 }))
        XCTAssertEqual(1000, computer.process({ 8 }))
        XCTAssertEqual(1001, computer.process({ 22 }))
    }
    
    func test_part2() throws {
        guard let data = try readInput(filename: "Day5.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { return XCTFail() }
        let computer = AdvancedIntCodeComputer(data: data)
        let output = computer.process({ 5 })
        XCTAssertEqual(3629692, output)
    }

}
