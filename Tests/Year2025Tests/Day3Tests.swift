import XCTest
import InputReader
import Year2025

class Day3Tests: XCTestCase {
    
    let input = Input("Day3.input", Bundle.module).lines
    let day = Day3()

    func test_part1() throws {
//        measure {
        XCTAssertEqual(17166, day.part1(input))
//        }
    }
    
    func test_part1_example() throws {
        let input = """
987654321111111
811111111111119
234234234234278
818181911112111
""".lines
        XCTAssertEqual(357, day.part1(input))
    }

    func test_part1_example2() throws {
        let input = """
3432324344242432243242442431213424312243322133232222316433433435212164332223444243334342533334253482
""".lines
        XCTAssertEqual(82, day.part1(input))
    }


    func test_part2() throws {
//        measure {
        XCTAssertEqual(169077317650774, day.part2(input))
//        }
    }
    
    func test_part2_example() throws {
        let input = """
987654321111111
811111111111119
234234234234278
818181911112111
""".lines
        XCTAssertEqual(3121910778619, day.part2(input))
    }

    func test_part2_example2() throws {
        let input = """
234234234234278
""".lines
        XCTAssertEqual(434234234278, day.part2(input))
    }

    func test_part2_example3() throws {
        let input = """
818181911112111
""".lines
        XCTAssertEqual(888911112111, day.part2(input))
    }

    func test_part2_example4() throws {
        let input = """
4426546555433545424424345444644242452452532444564422646557424354153538454225332755435544545533324152
""".lines
        XCTAssertEqual(875555555452, day.part2(input))
    }

    func test_part2_example5() throws {
        let input = """
4325282447422434333445212333343451413231333423353426332541123254243232342322553322244341312543932333
""".lines
        XCTAssertEqual(876555932333, day.part2(input))
    }

    func test_part2_example6() throws {
        let input = """
7233222122232253233222242323323223314121222243233553222212213232332233632222221633531222213332222322
""".lines
        XCTAssertEqual(766533332322, day.part2(input))
    }

    func test_part2_example7() throws {
        let input = """
2542562623212274282227172127123225532255466656628222232244712231262232124222523356442314912654421246
""".lines
        XCTAssertEqual(912654421246, day.part2(input))
    }
}
