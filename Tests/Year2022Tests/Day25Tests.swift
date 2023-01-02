import XCTest
import InputReader
import Year2022

class Day25Tests: XCTestCase {
    
    let input = Input("Day25.input", Bundle.module).lines
    let day = Day25()

    func test_part1() {
        XCTAssertEqual("2=0-2-1-0=20-01-2-20", day.part1(input))
    }
}

extension Day25Tests {
    func test_part1_example() {
        let input = """
1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
""".lines
        XCTAssertEqual("2=-1=0", day.part1(input))
    }
    
    func test_basic_example() {
        XCTAssertEqual(976, day.convert("2=-01"))
    }
    
    func test_convert() {
        XCTAssertEqual("2=-1=0", day.convert(4890))
        XCTAssertEqual(6, day.findMaxMultiplier(4890))
    }
}
