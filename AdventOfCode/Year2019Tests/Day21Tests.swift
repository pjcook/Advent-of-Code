//
//  Day21Tests.swift
//  Year2019Tests
//
//  Created by PJ COOK on 01/01/2020.
//  Copyright © 2020 Software101. All rights reserved.
//

import XCTest
import InputReader
@testable import Year2019

class Day21Tests: XCTestCase {

    func test_part1() throws {
       guard let input = try readInput(filename: "Day21.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        
        let droid = SpringDroid(input)
        droid.process("""
        NOT A J
        NOT B T
        OR T J
        NOT C T
        OR T J
        AND D J
        WALK

        """)
        
        let output = droid.finalOutput
        XCTAssertEqual(19352638, output)
    }
    
    func test_part2() throws {
        guard let input = try readInput(filename: "Day21.input", delimiter: ",", cast: Int.init, bundle: Year2019.bundle) as? [Int] else { throw Errors.invalidInput }
        
        let droid = SpringDroid(input)
        droid.process(part2SpringScript)
        
        let output = droid.finalOutput
        XCTAssertEqual(1141251258, output)
    }
    
    /*
         ABCDEFGHI
     ...@.............
     #####..#.########

         ABCDEFGHI
     ...@.............
     #####...#########

          ABCDEFGHI
     ....@............
     #####...#########

        ABCDEFGHI
     ..@..............
     #####.#.#..##.###

          ABCDEFGHI
     ....@............
     #####.#.#..##.###

          ABCDEFGHI
     ....@............
     #####..#####..###
      ABCDEFGHI
     @................
     #####..#####..###

     */
    let part2SpringScript = """
    NOT A J
    NOT B T
    OR T J
    NOT C T
    OR T J
    AND D J
    OR J T
    AND E T
    OR H T
    AND D T
    AND T J
    RUN

    """
    
    let sampleData = [
        "#..#.####":true,
        "#...#####":false,
        "...######":true,
        "##.#.#..#":false,
        ".#.#..##.":true,
        "..#####..":true,
        "####..###":false,
        ".#.##.#.#":true
    ]
    
    let sampleData2 = [
        "..#####..":true,
    ]
    
    func test_part2_sample1() {
        for (data, result) in sampleData {
            var input = parse(data)
            print(data)
            for instruction in part2SpringScript.split(separator: "\n").compactMap({ String($0) }) {
                input = process(instruction, input: input)
                print(instruction.replacingOccurrences(of: "OR", with: "OR "), "\tJ", input["J"]! ? "true " : "false", "\tT", input["T"]!)
            }
            XCTAssertEqual(result, input["J"], data)
        }
    }
    
    private func process(_ instruction: String, input: [String:Bool]) -> [String:Bool] {
        var output = input
        let split = instruction.split(separator: " ").map { String($0) }
        
        switch split[0] {
        case "NOT":
            output[split[2]] = !input[split[1]]!
        case "OR":
            output[split[2]] = input[split[1]]! || input[split[2]]!
        case "AND":
            output[split[2]] = input[split[1]]! && input[split[2]]!
        default: break
        }
        
        return output
    }
    
    private func parse(_ value: String) -> [String:Bool] {
        var output = ["T":false,"J":false]
        let input = value.map { String($0) == "#" }
        
        output["A"] = input[0]
        output["B"] = input[1]
        output["C"] = input[2]
        output["D"] = input[3]
        output["E"] = input[4]
        output["F"] = input[5]
        output["G"] = input[6]
        output["H"] = input[7]
        output["I"] = input[8]
        
        return output
    }

}
