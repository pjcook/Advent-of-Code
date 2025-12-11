import XCTest
import InputReader
import Year2025
import StandardLibraries

class Day11Tests: XCTestCase {
    
    let input = Input("Day11.input", Bundle.module).lines
    let day = Day11()

    func test_part1() throws {
        //        measure {
        XCTAssertEqual(749, day.part1(input))
        //        }
    }

    func test_part1_example() throws {
        let input = """
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
""".lines
        XCTAssertEqual(5, day.part1(input))
    }

    func test_part2() throws {
        // 156 LOW
        // 23 NO
        //        measure {
        let result = day.part2(input)
        XCTAssertEqual(156, result)
        XCTAssertTrue(result > 156)
        //        }
    }

    func test_part2_example() throws {
        let input = """
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
""".lines
        XCTAssertEqual(2, day.part2(input))
    }
}
