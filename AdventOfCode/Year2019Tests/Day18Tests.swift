//
//  Day18Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day18Tests: XCTestCase {

    func test_part1_sample_data1() throws {
        let input = [
            "#########",
            "#b.A.@.a#",
            "#########",
        ]
        let pathFinder = PathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(8, result)
    }
    
    func test_part1_sample_data2() throws {
        let input = [
            "########################",
            "#f.D.E.e.C.b.A.@.a.B.c.#",
            "######################.#",
            "#d.....................#",
            "########################",
        ]
        let pathFinder = PathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(86, result)
    }
    
    func test_part1_sample_data3() throws {
        let input = [
            "########################",
            "#...............b.C.D.f#",
            "#.######################",
            "#.....@.a.B.c.d.A.e.F.g#",
            "########################",
        ]
        let pathFinder = PathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(132, result)
    }
    
    func test_part1_sample_data4() throws {
        let input = [
            "#################",
            "#i.G..c...e..H.p#",
            "########.########",
            "#j.A..b...f..D.o#",
            "########@########",
            "#k.E..a...g..B.n#",
            "########.########",
            "#l.F..d...h..C.m#",
            "#################",
        ]
        let pathFinder = PathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(136, result)
    }
    
    func test_part1_sample_data5() throws {
        let input = [
            "########################",
            "#@..............ac.GI.b#",
            "###d#e#f################",
            "###A#B#C################",
            "###g#h#i################",
            "########################",
        ]
        let pathFinder = PathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(81, result)
    }
    
    func test_part1() throws {
        let input = try readInput(filename: "Day18.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
        let pathFinder = PathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(4248, result)
    }
    
    func test_part2_sample_data1() throws {
        let input = [
        "#############",
        "#g#f.D#..h#l#",
        "#F###e#E###.#",
        "#dCba@#@BcIJ#",
        "#############",
        "#nK.L@#@G...#",
        "#M###N#H###.#",
        "#o#m..#i#jk.#",
        "#############",
        ]
        
        let pathFinder = MultiPathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(72, result)
    }
    
    func test_part2_sample_data2() throws {
        let input = [
        "#############",
        "#g#f.D#..h#l#",
        "#F###e#E###.#",
        "#dCba@#@BcIJ#",
        "#############",
        "#nK.L@#@G...#",
        "#M###N#H###.#",
        "#o#m..#i#jk.#",
        "#############",
        ]
        
        let pathFinder = MultiPathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoorsBFS()
        XCTAssertEqual(72, result)
    }
    
    func test_part2_sample_data3() throws {
        let input = [
        "#############",
        "#g#f.D#..h#l#",
        "#F###e#E###.#",
        "#dCba@#@BcIJ#",
        "#############",
        "#nK.L@#@G...#",
        "#M###N#H###.#",
        "#o#m..#i#jk.#",
        "#############",
        ]
        
        let pathFinder = MultiPathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoorsSingleThreaded()
        XCTAssertEqual(72, result)
    }
    
    func test_remainigDoors() throws {
        let input = try readInput(filename: "Day18.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
        let pathFinder = PathFinder(input)
        let keys = pathFinder.keys.map { $0.value.toAscii()! }.sorted().joined()
        let remaining = pathFinder.remainingDoors([99,102,107])
        let remainingKeys = remaining.map { $0.toAscii()! }.sorted().joined()
        XCTAssertNotEqual(keys.uppercased(), remainingKeys)
        XCTAssertEqual(keys.count, remainingKeys.count+3)
    }
    
    func test_part2() throws {
        let input = try readInput(filename: "Day18_Part2.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
        
        let pathFinder = MultiPathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoors()
        XCTAssertEqual(1878, result)
    }
    
    func test_part2SingleThreaded() throws {
        let input = try readInput(filename: "Day18_Part2.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
        
        let pathFinder = MultiPathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoorsSingleThreaded()
        XCTAssertEqual(1878, result)
    }
    
    func test_part2BFS() throws {
        let input = try readInput(filename: "Day18_Part2.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
        
        let pathFinder = MultiPathFinder(input)
        let result = pathFinder.calculateShortestPathToUnlockAllDoorsBFS()
        XCTAssertEqual(1878, result)
    }

}
