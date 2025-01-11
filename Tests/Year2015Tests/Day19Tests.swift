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
    
    func test_part2() throws {
        XCTAssertEqual(207, try day.part2b(input))
    }

    func test_stringReplacement() {
        let molecule = "afghsdfghjkl"
        let from = "fgh"
        let to = "d"
        var results = [String]()
        molecule.ranges(of: from).forEach {
            results.append(molecule.replacingCharacters(in: $0, with: to))
        }
        print(results)
    }
    
    func test_part2_test1() throws {
        let input = """
        e => H
        e => O
        H => HO
        H => OH
        O => HH
        
        HOH
        """.lines
        XCTAssertEqual(3, try day.part2b(input))
    }
    
    func test_part2_test2() throws {
        let input = """
        e => H
        e => O
        H => HO
        H => OH
        O => HH
        
        HOHOHO
        """.lines
        XCTAssertEqual(6, try day.part2b(input))
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
    
    func test_example2() throws {
        let input = """
e => H
e => O
H => HO
H => OH
O => HH

HOH
""".lines
        XCTAssertEqual(3, try day.part2b(input))
    }
}
