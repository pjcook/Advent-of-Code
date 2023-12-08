import XCTest
import InputReader
import StandardLibraries
import Year2023

class Day8Tests: XCTestCase {
    
    let input = Input("Day8.input", Bundle.module).lines
    let day = Day8()

    func test_part1() {
//        measure {
        XCTAssertEqual(18157, day.part1(input))
//        }
    }
    
    func test_parser() {
        let input = """
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
""".lines
        let (directions, nodes) = day.parse(input)
        XCTAssertEqual(directions.count, 2)
        XCTAssertEqual(nodes.count, 7)
        
        XCTAssertEqual(directions, [.right, .left])
    }
    
    func test_part1_example1() {
        let input = """
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
""".lines
        XCTAssertEqual(2, day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(14299763833181, day.part2(input))
//        }
    }
    
    func test_part2_example1() {
        let input = """
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
""".lines
        XCTAssertEqual(6, day.part2(input))
    }
}
