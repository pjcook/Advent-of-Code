import XCTest
import InputReader
import Year2016

class Day6Tests: XCTestCase {
    
    let input = Input("Day6.input", Bundle.module).lines
    let day = Day6()

    func test_part6() {
//        measure {
        XCTAssertEqual("umcvzsmw", day.part1(input))
//        }
    }
    
    func test_part1_example() {
        let input = """
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
""".lines
        XCTAssertEqual("easter", day.part1(input))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual("rwqoacfz", day.part2(input))
//        }
    }
    
    func test_part2_example() {
        let input = """
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
""".lines
        XCTAssertEqual("advent", day.part2(input))
    }
}
