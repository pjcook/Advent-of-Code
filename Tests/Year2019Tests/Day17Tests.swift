//
//  Day17Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 17/12/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import XCTest
import InputReader
import Year2019

class Day17Tests: XCTestCase {

    func test_part1() throws {
        let input = try readInputAsIntegers(filename: "Day17.input", delimiter: ",", bundle: .module)
        let robot = VacuumRobot(input)
        let result = robot.calibrate()
        robot.drawMapInConsole()
        XCTAssertEqual(5740, result)
    }
    
    func test_part2_sample_data1() throws {
        
    }
    
    func test_part2() throws {
        var input = try readInputAsIntegers(filename: "Day17.input", delimiter: ",", bundle: .module)
        input[0] = 2
        let robot = VacuumRobot(input)
        let instructions = "A,C,C,A,B,A,B,A,B,C\nR,6,R,6,R,8,L,10,L,4\nL,4,L,12,R,6,L,10\nR,6,L,10,R,8\nn\n"
        robot.populateInstructions(instructions)
        _ = robot.calibrate()
        XCTAssertEqual(1022165, robot.collectedDust)
    }
    
    func test_part2_chris() throws {
        var input = try readInputAsIntegers(filename: "Day17_chris.input", delimiter: ",", bundle: .module)
        input[0] = 2
        let robot = VacuumRobot(input)
        let instructions = """
        A,B,A,C,A,B,C,A,B,C
        R,12,R,4,R,10,R,12
        R,6,L,8,R,10
        L,8,R,4,R,4,R,6
        n\n
        """
        robot.populateInstructions(instructions)
        let result = robot.calibrate()
        XCTAssertEqual(7600, result)
    }
    
    func test_part2_ascii_commands() {
        let message = "#,.,A,B,C,R,L,^,v,<,>,12,10\n"
        for v in message.utf8 {
            print(Int(v))
        }
    }

}
