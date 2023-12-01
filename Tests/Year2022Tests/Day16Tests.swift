import XCTest
import InputReader
import Year2022

class Day16Tests: XCTestCase {
    
    let input = Input("Day16.input", Bundle.module).input
    let day = Day16()

    func test_part1() {
//        measure {
        XCTAssertEqual(2080, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(2752, day.part2(input))
//        }
    }
}

extension Day16Tests {
    func test_compressGraph() {
        let results = day.parse(input)
        let compressed = day.compressGraph(chambers: results)
        XCTAssertEqual(16, compressed.count)
        
        let start = compressed.first(where: { $0.key == "AA" })!
        XCTAssertEqual(5, start.value.destinations.count)
        XCTAssertNotNil(start.value.destinations.first(where: { compressed[$0.id]!.flowRate == 18 }))
        XCTAssertNotNil(start.value.destinations.first(where: { compressed[$0.id]!.flowRate == 7 }))
        XCTAssertNotNil(start.value.destinations.first(where: { compressed[$0.id]!.flowRate == 5 }))
        XCTAssertNotNil(start.value.destinations.first(where: { compressed[$0.id]!.flowRate == 4 }))
        XCTAssertNotNil(start.value.destinations.first(where: { compressed[$0.id]!.flowRate == 13 }))
    }
    
    func test_part1_example() {
        let input = """
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""
        let compressed = day.compressGraph(chambers: day.parse(input))
        XCTAssertEqual(7, compressed.count)

        let bb = compressed["BB"]!
        XCTAssertEqual(2, bb.destinations.count)
        XCTAssertNotNil(bb.destinations.first(where: { $0.id == "AA" }))
        XCTAssertNotNil(bb.destinations.first(where: { $0.id == "CC" }))

        XCTAssertEqual(1651, day.part1(input))
        
    }
    
    func test_part1_parse() {
        let input = """
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""
        let results = day.parse(input)
        print(results)
    }
}
