import XCTest
import InputReader
import StandardLibraries
import Year2015

class Day19Tests: XCTestCase {
    
    let input = Input("Day19.input", .module).lines
    let day = Day19()

    func test_part1() {
        XCTAssertEqual(576, day.part1b(input))
    }
    
    func test_part2() {
        XCTAssertEqual(6, day.part2(input))
    }
    
//    func test_part2_example() {
//        let input = "ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF"
//        let count = input.count
//        let regexAr = try! RegularExpression(pattern: "(Ar)")
//        let ar = regexAr.matches(in: input).count
//        let regexRn = try! RegularExpression(pattern: "(Rn)")
//        let rn = regexRn.matches(in: input).count
//        let regexY = try! RegularExpression(pattern: "(Y)")
//        let y = regexY.matches(in: input).count
//
//        let result = count - ar - rn - 2 * y - 1
//        print(result)
//    }
    
    func test_part2_test1() {
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
    
    func test_part2_test2() {
        let input = """
        e => H
        e => O
        H => HO
        H => OH
        O => HH
        
        HOHOHO
        """.lines
        XCTAssertEqual(6, day.part2(input))
    }
    
    func test_parsing() {
        let (items, molecule) = day.parse(input)
        XCTAssertEqual(13, items.count)
        XCTAssertEqual(506, molecule.count)
        XCTAssertEqual(43, items.values.flatMap({ $0 }).count)
        XCTAssertEqual("ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF", molecule)
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
    
    func test_exampleb() {
        let input = """
H => HO
H => OH
O => HH

HOH
""".lines
        XCTAssertEqual(4, day.part1b(input))
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
