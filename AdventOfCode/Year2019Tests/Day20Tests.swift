//
//  Day20Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 19/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day20Tests: XCTestCase {

    func test_part1_sample_data1() throws {
        let input = try readInput(filename: "Day20_sample1.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self))
        let (map, portals) = parsePlutoMap(input)
        XCTAssertEqual(8, portals.count)
        XCTAssertFalse(map.isEmpty)
//        print(portals.sorted { $0.value < $1.value })
//        drawMap(map, tileMap: [0:"🟤", 1:"⚪️", 2:"⚫️", 3:"🟠", -1:"⚫️"])
        
        let maze = PortalMaze(rawMap: map, keys: portals)
        let result = maze.findShortestRoute()
        XCTAssertEqual(23, result)
    }
    
    func test_part1_sample_data2() throws {
        let input = try readInput(filename: "Day20_sample2.input", delimiter: "\n", cast: String.init, bundle: Bundle(for: Self.self))
        let (map, portals) = parsePlutoMap(input)
        XCTAssertEqual(22, portals.count)
        XCTAssertFalse(map.isEmpty)
//        print(portals.sorted { $0.value < $1.value })
//        drawMap(map, tileMap: [0:"🟤", 1:"⚪️", 2:"⚫️", 3:"🟠", -1:"⚫️"])
        
        let maze = PortalMaze(rawMap: map, keys: portals)
        let result = maze.findShortestRoute()
        XCTAssertEqual(58, result)
    }
    
    func test_part1_sample_data3() throws {
        
    }
    
    func test_part1() throws {
        let input = try readInput(filename: "Day20.input", delimiter: "\n", cast: String.init, bundle: Year2019.bundle)
                let (map, portals) = parsePlutoMap(input)
                XCTAssertEqual(56, portals.count)
                XCTAssertFalse(map.isEmpty)
        //        print(portals.sorted { $0.value < $1.value })
        //        drawMap(map, tileMap: [0:"🟤", 1:"⚪️", 2:"⚫️", 3:"🟠", -1:"⚫️"])
                
                let maze = PortalMaze(rawMap: map, keys: portals)
                let result = maze.findShortestRoute()
                XCTAssertEqual(594, result)

    }
    
    func test_part2_sample_data1() throws {
        
    }
    
    func test_part2_sample_data2() throws {
        
    }
    
    func test_part2_sample_data3() throws {
        
    }
    
    func test_part2() throws {
        let result = 6812
        // Now write the code
        XCTAssertEqual(6812, result)
    }

}
