//
//  Day12Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 11/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day12Tests: XCTestCase {
    let sampleInput = parseMoonInput(try! readInputAsStrings(filename: "Day12_sample_data1.input", bundle: Bundle(for: Day12Tests.self))).map { Moon($0) }
    let input = parseMoonInput(try! readInputAsStrings(filename: "Day12.input", bundle: Year2019.bundle)).map { Moon($0) }
    let sample2Input = parseMoonInput(try! readInputAsStrings(filename: "Day12_sample_data2.input", bundle: Bundle(for: Day12Tests.self))).map { Moon($0) }
    
    func test_part1_sample_data1() throws {
        for moon in sampleInput {
            moon.otherMoons = sampleInput.filter { $0 != moon }
        }
        let result = processPositions(moons: sampleInput, numberOfSteps: 10)
        XCTAssertEqual(179, result)
    }
    
//    func test_part1_sample_data2() throws {
//        for moon in sampleInput {
//            moon.otherMoons = sampleInput.filter { $0 != moon }
//        }
//        let result = processPositions(moons: sampleInput, numberOfSteps: 100)
//        XCTAssertEqual(1940, result)
//    }
    
    func test_part1() throws {
        
        for moon in input {
            moon.otherMoons = input.filter { $0 != moon }
        }
        let result = processPositions(moons: input, numberOfSteps: 1000)
        XCTAssertEqual(13045, result)
    }
    
    func test_part2_sample_data1() throws {
        for moon in sampleInput {
            moon.otherMoons = sampleInput.filter { $0 != moon }
        }
        let result = findRepeatingOrbits(moons: sampleInput, numberOfSteps: 2780)
        XCTAssertEqual(2772, result)
    }
    
    func test_part2_sample_data2() throws {
        for moon in sample2Input {
            moon.otherMoons = sample2Input.filter { $0 != moon }
        }
        let result = findRepeatingOrbits(moons: sample2Input, numberOfSteps: 4686775000)
        XCTAssertEqual(4686774924, result)
    }
    
    func test_part2() throws {
        for moon in input {
            moon.otherMoons = input.filter { $0 != moon }
        }
        let result = findRepeatingOrbits(moons: input, numberOfSteps: Int.max)
        XCTAssertEqual(344724687853944, result)
    }

}
