import XCTest
import InputReader
import Year2021

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Year2021.bundle).lines
    let day = Day3()

    func test_part1() {
//        measure {
        XCTAssertEqual(738234, day.part1(input))
//        }
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(3969126, day.part2(input))
//        }
    }
    
    func test_example() {
        let input = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
""".lines
        let diagnostic = day.calculateGammaAndEpsilon(input)
        XCTAssertEqual(22, diagnostic.gammaRate)
        XCTAssertEqual(9, diagnostic.epsilonRate)
    }
    
    func test_example_oxygen() {
        let input = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
""".lines
        let oxygen = day.calculateOxygenGeneratorRating(input)
        XCTAssertEqual(23, oxygen)
    }
    
    func test_example_co2() {
        let input = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
""".lines
        let oxygen = day.calculateCO2ScrubberRating(input)
        XCTAssertEqual(10, oxygen)
    }
}
