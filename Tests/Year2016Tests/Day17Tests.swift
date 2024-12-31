import XCTest
import InputReader
import Year2016

class Day17Tests: XCTestCase {
    
    let day = Day17()

    func test_part1() {
//        measure {
        XCTAssertEqual("DRRDRLDURD", day.part1("pvhmgsws"))
//        }
    }
    
    func test_part1_example() {
        XCTAssertEqual("-1", day.part1("hijkl"))
        XCTAssertEqual("DDRRRD", day.part1("ihgpwlah"))
        XCTAssertEqual("DDUDRLRRUDRD", day.part1("kglvqrro"))
        XCTAssertEqual("DRURDRUDDLLDLUURRDULRLDUUDDDRR", day.part1("ulqzkmiv"))
    }
    
    func test_part2() {
//        measure {
        XCTAssertEqual(618, day.part2("pvhmgsws"))
//        }
    }
    
    func test_part2_example() {
        XCTAssertEqual(370, day.part2("ihgpwlah"))
        XCTAssertEqual(492, day.part2("kglvqrro"))
        XCTAssertEqual(830, day.part2("ulqzkmiv"))
    }
}
