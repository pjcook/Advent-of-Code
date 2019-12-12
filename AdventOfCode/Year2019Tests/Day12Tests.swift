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

    func test_part1_sample_data1() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data1.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)))
        let result = processPositions(moons: input, numberOfSteps: 10)
        XCTAssertEqual(179, result)
    }
    
    func test_part1_sample_data2() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data2.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)))
        let result = processPositions(moons: input, numberOfSteps: 100)
        XCTAssertEqual(1940, result)
    }
    
    func test_part1_sample_data1b() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data1.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self))).map { Moon($0) }
        for moon in input {
            moon.otherMoons = input.filter { $0 != moon }
        }
        let result = processPositions2(moons: input, numberOfSteps: 10)
        XCTAssertEqual(179, result)
    }
    
    func test_part1_sample_data2b() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data2.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self))).map { Moon($0) }
        for moon in input {
            moon.otherMoons = input.filter { $0 != moon }
        }
        let result = processPositions2(moons: input, numberOfSteps: 100)
        XCTAssertEqual(1940, result)
    }
    
    func test_part1() throws {
        let input = parseMoonInput(try readInput(filename: "Day12.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle))
        let result = processPositions(moons: input, numberOfSteps: 1000)
        XCTAssertEqual(13045, result)
    }
    
    func test_part2_sample_data1() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data1.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)))
        let result = findRepeatingOrbits(moons: input, numberOfSteps: 2780)
        XCTAssertEqual(2772, result)
    }
    
    func test_part2_sample_data2() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data2.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self)))
        let result = findRepeatingOrbits(moons: input, numberOfSteps: 4686775000)
        XCTAssertEqual(4686774924, result)
    }
    
    func test_part2_sample_data1b() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data1.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self))).map { Moon($0) }
        for moon in input {
            moon.otherMoons = input.filter { $0 != moon }
        }
        let result = findRepeatingOrbits2(moons: input, numberOfSteps: 2780)
        XCTAssertEqual(2772, result)
    }
    
    func test_part2_sample_data2b() throws {
        let input = parseMoonInput(try readInput(filename: "Day12_sample_data2.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self))).map { Moon($0) }
        for moon in input {
            moon.otherMoons = input.filter { $0 != moon }
        }
        let result = findRepeatingOrbits2(moons: input, numberOfSteps: 4686775000)
        XCTAssertEqual(4686774924, result)
    }
    
    func test_part2() throws {
        let input = parseMoonInput(try readInput(filename: "Day12.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)).map { Moon($0) }
        for moon in input {
            moon.otherMoons = input.filter { $0 != moon }
        }
        let result = findRepeatingOrbits2(moons: input, numberOfSteps: Int.max)
        XCTAssertEqual(4686774924, result)
    }

}
