import XCTest
import InputReader
import Year2017

class Day7Tests: XCTestCase {
    
    let input = Input("Day7.input", Bundle.module).lines
    let day = Day7()

    func test_part1() {
//        measure {
        XCTAssertEqual("vgzejbd", day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
""".lines
        XCTAssertEqual("tknk", day.part1(input))
    }
    
    func test_part2() {
//        measure {
        // low 171
        XCTAssertEqual(1226, day.part2(input, rootID: "vgzejbd"))
//        }
    }
    
    func test_part2_example() {
        let input = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
""".lines
        XCTAssertEqual(60, day.part2(input, rootID: "tknk"))
    }
}
