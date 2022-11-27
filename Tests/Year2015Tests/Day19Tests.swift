import XCTest
import InputReader
import Year2015

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", .module).lines
    let day = Day19()

    func test_part1() {
        XCTAssertEqual(576, day.part1(input))
    }
    
    func test_part2() {
//        XCTAssertEqual(0, day.part2(input))
    }
    
    func test_parsing() {
        let (items, molecule) = day.parse(input)
        XCTAssertEqual(13, items.count)
        XCTAssertEqual(506, molecule.count)
        XCTAssertEqual(43, items.values.flatMap({ $0 }).count)
        XCTAssertEqual("ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF", molecule)
    }
    
    func test_countNonOverlapping() {
        XCTAssertEqual(1, day.countNonOverlapping("abc", content: "jhabcuy"))
        XCTAssertEqual(2, day.countNonOverlapping("abc", content: "jhabcuyabc"))
        XCTAssertEqual(2, day.countNonOverlapping("bcbc", content: "jbcabcbchjjgbcbcbcefefe"))
    }
    
    func test_example() {
        let input = """
H => HO
H => OH
O => HH

HOH
""".lines
        XCTAssertEqual(4, day.part1(input))
    }
    
    func test_example2() {
        let input = """
e => H
e => O
H => HO
H => OH
O => HH

HOH
""".lines
        XCTAssertEqual(3, day.part2(input))
    }
}
