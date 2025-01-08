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
        // low 201
        XCTAssertEqual(201, day.part2(input))
    }
    
    func test_part2b() {
        // low 201
        // not 479
        // not 252
        XCTAssertEqual(252, day.part2b(input))
    }
    
    func test_part2c() {
        // not 411
        // not 412
        // not 479
        // not 257
        XCTAssertEqual(412, day.part2c(input))
    }
    
    func test_part2d() throws {
        // not 411
        XCTAssertEqual(412, try day.part2d(input))
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
